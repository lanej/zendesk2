class Zendesk2::Client::UserIdentities < Zendesk2::Collection
  include Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::Client::UserIdentity

  attribute :user_id

  self.collection_method = :get_user_identities
  self.collection_root   = "identities"
  self.model_method      = :get_user_identity
  self.model_root        = "identity"
  self.search_type       = "identity"

  def create(attributes={})
    super(attributes.merge("user_id" => self.user_id))
  end

  def create!(attributes={})
    super(attributes.merge("user_id" => self.user_id))
  end

  def all(params={})
    body = connection.send(collection_method, params.merge("user_id" => self.user_id)).body

    collection = self.clone.load(body[collection_root])
    collection.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
    collection
  end

  def get(user_id, user_identity_id)
    if data = self.connection.send(model_method, {"user_id" => user_id, "id" => user_identity_id}).body[self.model_root]
      new(data)
    end
  rescue Zendesk2::Error
    nil
  end
end
