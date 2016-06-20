# frozen_string_literal: true
# Defines {#search} on relevant collections
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
  def search(terms, params = {})
    query = (terms.is_a?(Hash) ? search_by_hash(terms) : search_by_string(terms))

    body = cistern.send(self.class.search_request, query, params).body
    data = body.delete('results')

    if data
      load(data)
      merge_attributes(Cistern::Hash.slice(body, 'count', 'next_page', 'previous_page').merge('filtered' => true))
      self
    end
  end

  private

  def search_by_hash(terms)
    terms['type'] = self.class.search_type if self.class.search_type
    terms.merge(self.class.scopes.inject({}) do |r, k|
      val = public_send(k)
      val.nil? ? r : r.merge(k.to_s => val)
    end,).map { |k, v| "#{k}:#{v}" }.join(' ',)
  end

  def search_by_string(terms)
    additional_terms = []
    additional_terms = ["type:#{self.class.search_type}"] if self.class.search_type
    additional_terms += self.class.scopes.inject([]) do |r, k|
      val = public_send(k)
      val.nil? ? r : ["#{k}:#{val}"]
    end

    additional_terms.inject(terms.to_s) do |qualified_search, qualification|
      if !qualified_search.include?(qualification)
        "#{qualified_search} #{qualification}"
      else
        qualified_search
      end
    end
  end

  # define {#search_request} for atypical searches
  module Attributes
    attr_accessor :search_type
    attr_writer :search_request

    def search_request
      @search_request ||= :search
    end
  end
end
