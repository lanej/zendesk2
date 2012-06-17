class Zendesk2::Client::Users < Cistern::Collection
  include Zendesk2::PagedCollection

  model Zendesk2::Client::User

  collection_method :get_users
  collection_root "users"

  model_method :get_user
  model_root "user"

  def current
    new(connection.get_current_user.body["user"])
  end

  # usernames and email address
  def search(term)
    body = connection.search_user("query" => term).body
    data = body["results"]
    load(data)
    merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
  end
end
