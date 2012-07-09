class Zendesk2::Client::Users < Cistern::Collection
  include Zendesk2::PagedCollection

  model Zendesk2::Client::User

  self.collection_method= :get_users
  self.collection_root= "users"
  self.model_method= :get_user
  self.model_root= "user"

  def current
    new(connection.get_current_user.body["user"])
  end

  def search(term)
    body = connection.search_user("query" => term).body
    if data = body.delete("results")
      load(data)
    end
    merge_attributes(body)
  end
end
