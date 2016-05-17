module Zendesk2::Searchable
  def self.included(klass)
    klass.send(:extend, Zendesk2::Searchable::Attributes)
    # @note signal to underlying collection that a search request
    #       must be use when requesting associated pages
    klass.send(:attribute, :filtered, type: :boolean)
  end

  # Search for resources of a certain type.
  #
  # If you need more control over your search (see Zendesk2::Real#search)
  #
  # @example search with a simple hash
  #   client.users.search("email" => "jlane@engineyard.com")
  # @example search with fully qualified query
  #   client.tickets.search("created>2012-06-17+type:ticket+organization:'Mondocam Photo'")
  #
  # @param [String, Hash] seach terms.  This will be converted to a qualified Zendesk search String
  # @see http://developer.zendesk.com/documentation/rest_api/search.html
  def search(terms, params={})
    query = if terms.is_a?(Hash)
              terms.merge!("type" => self.class.search_type) if self.class.search_type
              terms.merge(self.class.scopes.inject({}) { |r,k|
                val = public_send(k)
                val.nil? ? r : r.merge(k.to_s => val)
              }).map { |k,v| "#{k}:#{v}" }.join(" ")
            else
              additional_terms = []
              additional_terms = ["type:#{self.class.search_type}"] if self.class.search_type
              additional_terms += self.class.scopes.inject([]) { |r,k|
                val = public_send(k)
                val.nil? ? r : ["#{k}:#{val}"]
              }

              additional_terms.inject(terms.to_s) do |qualified_search, qualification|
                if !qualified_search.include?(qualification)
                  "#{qualified_search} #{qualification}"
                else
                  qualified_search
                end
              end
            end

    body = service.send(self.class.search_request, query, params).body

    if data = body.delete("results")
      self.load(data)
      self.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page").merge("filtered" => true))
      self
    end
  end

  module Attributes
    attr_accessor :search_type
    attr_writer :search_request

    def search_request
      @search_request ||= :search
    end
  end
end
