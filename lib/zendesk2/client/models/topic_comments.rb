class Zendesk2::Client::TopicComments < Zendesk2::Collection
  include Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::Client::TopicComment

  attribute :topic_id, type: :integer

  self.collection_method = :get_topic_comments
  self.collection_root   = "topic_comments"
  self.model_method      = :get_topic_comment
  self.model_root        = "topic_comment"
  self.search_type       = "topic_comment"

  def all(params={})
    body = connection.send(collection_method, params.merge("topic_id" => self.topic_id)).body

    collection = self.clone.load(body[collection_root])
    collection.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
    collection
  end

  def get(topic_id, topic_comment_id)
    if data = self.connection.send(model_method, {"topic_id" => topic_id, "id" => topic_comment_id}).body[self.model_root]
      new(data)
    end
  rescue Zendesk2::Error
    nil
  end
end
