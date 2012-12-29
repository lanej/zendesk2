module Zendesk2::Searchable
  def self.included(klass)
    klass.send(:extend, Zendesk2::Searchable::Attributes)
  end

  def search(parameters)
    body = connection.send(self.class.search_request, parameters.merge("type" => self.class.search_type)).body
    if data = body.delete("results")
      load(data)
    end
    merge_attributes(body)
  end

  module Attributes
    attr_accessor :search_type
    attr_writer :search_request

    def search_request
      @search_request ||= :search
    end
  end
end
