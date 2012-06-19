require 'spec_helper'

describe "organizations" do
  let(:client) { create_client }
  it_should_behave_like "a resource",
    :organizations,
    lambda { {name: Zendesk2.uuid} },
    lambda { {name: Zendesk2.uuid} }

  describe do
    let(:organization) { client.organizations.create(name: Zendesk2.uuid) }
    it "should get #users" do
      user = client.users.create(email: "#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, organization_id: organization.id)
      organization.users.should include user
    end

    it "should get #tickets" do
      user = client.users.create(email: "#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, organization_id: organization.id)
      ticket = client.tickets.create(subject: "#{Zendesk2.uuid}@example.org", description: Zendesk2.uuid, requester: user)
      organization.tickets.should include ticket
    end
  end
end
