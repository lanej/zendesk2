class Zendesk2::Client::Users < Cistern::Collection

  model Zendesk2::Client::User

  attribute :count
  attribute :next_page_link, :aliases => "next_page"
  attribute :previous_page_link, :aliases => "previous_page"

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

  def all(params={})
    body = connection.get_users(params).body

    load(body["users"])
    merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
  end

  def get(id)
    if data = connection.get_user("id" => id).body["user"]
      new(data)
    end
  end

  def next_page
    all("url" => next_page_link) if next_page_link
  end

  def previous_page
    all("url" => previous_page_link) if previous_page_link
  end
end
