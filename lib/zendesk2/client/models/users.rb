class Zendesk2::Client::Users < Zendesk2::Collection
  include Zendesk2::Searchable

  model Zendesk2::Client::User

  self.collection_method = :get_users
  self.collection_root   = "users"
  self.model_method      = :get_user
  self.model_root        = "user"
  self.search_type       = "user"
  self.search_request    = :search_user

  def current
    new(connection.get_current_user.body["user"])
  end
end
