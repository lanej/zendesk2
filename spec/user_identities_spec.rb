require 'spec_helper'

describe "user_identities" do
  let(:client) { create_client }
  let(:user)   { client.users.create(email: "zendesk2+#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, verified: true) }
  it_should_behave_like "a resource",
    :identities,
    lambda { {value: "ey+#{Zendesk2.uuid}@example.org", type: "email", user_id: user.id} },
    lambda { {verified: true} },
    {
      :fetch_params => lambda {|uc| {"user_id" => uc.user_id, "id" => uc.id}},
      :collection   => lambda { client.user_identities(user_id: user.id) },
    }
end
