class Zendesk2::Users < Zendesk2::Collection
  include Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::User

  self.collection_method = :get_users
  self.collection_root   = "users"
  self.model_method      = :get_user
  self.model_root        = "user"
  self.search_type       = "user"
  self.search_request    = :search_user

  def current
    new(service.get_current_user.body["user"])
  end
end
