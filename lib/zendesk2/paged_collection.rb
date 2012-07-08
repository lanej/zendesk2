module Zendesk2::PagedCollection
  def self.included(klass)
    klass.send(:attribute, :count)
    klass.send(:attribute, :next_page_link, {:aliases => "next_page"})
    klass.send(:attribute, :previous_page_link, {:aliases => "previous_page"})
    klass.send(:include, Zendesk2::Errors)
    klass.send(:extend, Zendesk2::PagedCollection::Attributes)
  end

  def collection_method; self.class.collection_method; end
  def collection_root; self.class.collection_root; end
  def model_method; self.class.model_method; end
  def model_root; self.class.model_root; end

  def all(params={})
    body = connection.send(collection_method, params).body

    collection = self.clone.load(body[collection_root])
    collection.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
    collection
  end

  def get(id)
    if data = self.connection.send(model_method, {"id" => id}).body[self.model_root]
      new(data)
    end
  rescue not_found
    nil
  end

  def next_page
    all("url" => next_page_link) if next_page_link
  end

  def previous_page
    all("url" => previous_page_link) if previous_page_link
  end

  module Attributes
    attr_accessor :collection_method, :collection_root, :model_method, :model_root
  end
end
