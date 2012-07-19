module Zendesk2::Searchable
  def self.included(klass)
    klass.send(:extend, Zendesk2::Searchable::Attributes)
  end

  def search(parameters)
    body = connection.search(parameters.merge("type" => self.class.search_type)).body
    if data = body.delete("results")
      load(data)
    end
    merge_attributes(body)
  end

  module Attributes
    attr_accessor :search_type
  end
end
