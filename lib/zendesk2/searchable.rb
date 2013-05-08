module Zendesk2::Searchable
  def self.included(klass)
    klass.send(:extend, Zendesk2::Searchable::Attributes)
  end

  def search(parameters)
    body = connection.send(self.class.search_request, parameters.merge("type" => self.class.search_type), self.class.search_options).body
    if data = body.delete(self.class.search_options[:results_collection_name] || "results")
      collection = self.clone.load(data)
      collection.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
      collection
    end
  end

  module Attributes
    attr_accessor :search_type
    attr_accessor :search_options
    attr_writer :search_request

    def search_options
      @search_options ||= {}
    end

    def search_request
      @search_request ||= :search
    end
  end
end
