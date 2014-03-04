require 'spec_helper'

describe "memberships" do
  let(:client) { create_client }
  let(:user)   { client.users.create(email: "zendesk2+#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, verified: true) }
  let(:organization)   { client.organizations.create(name: Zendesk2.uuid) }
  it_should_behave_like "a resource",
    :memberships,
    lambda { {organization_id: organization.id, user_id: user.id} },
    lambda { },
    {
      :fetch_params => lambda {|uc| {"user_id" => uc.user_id, "id" => uc.id}},
      :collection   => lambda { client.memberships(user_id: user.id) },
    }
end
