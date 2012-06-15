class Zendesk::Client::Users < Cistern::Collection

  model Zendesk::Client::User

  attribute :count
  attribute :next_page_link, :aliases => "next_page"
  attribute :prev_page_link, :aliases => "prev_page"

  def current
    data = connection.get_current_user.body["user"]
    new(data)
  end

  def all
    body = connection.get_users.body
    load(body["users"])
    merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "prev_page"))
  end

  def get(id)
    data = connection.get_user("id" => id).body["user"]

    new(data)
  end
end
