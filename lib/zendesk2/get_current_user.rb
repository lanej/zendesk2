class Zendesk2::GetCurrentUser < Zendesk2::Request
  request_method :get
  request_path { |_| "/users/me.json" }

  def mock
    service.get_user("user" => {"id" => service.current_user.fetch("id")})
  end
end
