class Zendesk::Client::Users < Cistern::Collection

  model Zendesk::Client::User

  def current
    data = connection.get_current_user.body["user"]
    new(data)
  end
end
