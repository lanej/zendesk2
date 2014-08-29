module Zendesk2::Searchable
  def self.included(klass)
    klass.send(:extend, Zendesk2::Searchable::Attributes)
  end

  # Search for resources of a certain type.
  #
  # If you need more control over your search (see Zendesk2::Client::Real#search)
  #
  # @example search with a simple hash
  #   client.users.search("email" => "jlane@engineyard.com")
  # @example search with fully qualified query
  #   client.tickets.search("created>2012-06-17+type:ticket+organization:'Mondocam Photo'")
  #
  # @param [String, Hash] seach terms.  This will be converted to a qualified Zendesk search String
  # @see http://developer.zendesk.com/documentation/rest_api/search.html
  def search(terms)
    query = if terms.is_a?(Hash)
              terms.merge("type" => self.class.search_type).map { |k,v| "#{k}:#{v}" }.join(" ")
            else
              type_qualification = "type:#{self.class.search_type}"
              qualified_search   = terms.to_s

              if qualified_search.include?(type_qualification)
                qualified_search
              else
                "#{qualified_search} #{type_qualification}"
              end
            end

    body = connection.send(self.class.search_request, query).body

    if data = body.delete("results")
      collection = self.clone.load(data)
      collection.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
      collection
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
