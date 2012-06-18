require 'spec_helper'

describe "organizations" do
  let(:client) { create_client }
  it_should_behave_like "a resource",
    :organizations,
    lambda { {name: Zendesk2.uuid} },
    lambda { {name: Zendesk2.uuid} }

  it "should get #users" do
    organization = client.organizations.create(name: Zendesk2.uuid)
    user = client.users.create(email: "#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, organization_id: organization.id)
    organization.users.should include user
  end
end
