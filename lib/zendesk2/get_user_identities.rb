# frozen_string_literal: true
class Zendesk2::GetUserIdentities
  include Zendesk2::Request

  request_path { |r| "/users/#{r.user_id}/identities.json" }

  page_params!

  def user_id
    params.fetch('user_id').to_i
  end

  def mock
    identities = cistern.data[:identities].values.select { |a| a['user_id'] == user_id }

    page(identities, root: 'identities')
  end
end
