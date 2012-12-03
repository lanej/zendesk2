class Zendesk2::Client::Users < Zendesk2::Collection
  include Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::Client::User

  self.collection_method= :get_users
  self.collection_root= "users"
  self.model_method= :get_user
  self.model_root= "user"
  self.search_type= "user"

  def current
    new(connection.get_current_user.body["user"])
  end

  def search_by_email(email)
    response = connection.search_users_by_email(:email => email).body['users']
    return new(response.first) if response.size > 0
    nil
  end
end
