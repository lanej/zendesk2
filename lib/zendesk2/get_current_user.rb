# frozen_string_literal: true
class Zendesk2::GetCurrentUser
  include Zendesk2::Request

  request_method :get
  request_path { |_| '/users/me.json' }

  def mock
    cistern.get_user('user' => { 'id' => cistern.current_user.fetch('id') })
  end
end
