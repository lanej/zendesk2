require 'spec_helper'

describe "organizations" do
  let(:client) { create_client }
  it_should_behave_like "a resource",
    :organizations,
    lambda { {name: Zendesk2.uuid} },
    lambda { {name: Zendesk2.uuid} }

  describe "with an organization" do
    let(:organization) { client.organizations.create(name: Zendesk2.uuid) }
    it "should get #users" do
      user = client.users.create(email: "#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, organization: organization)
      organization.users.should include user
    end

    it "should get #tickets" do
      user = client.users.create(email: "#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, organization: organization)
      ticket = client.tickets.create(subject: "#{Zendesk2.uuid}@example.org", description: Zendesk2.uuid, requester: user)
      organization.tickets.should include ticket
    end

    it "should hate non-unique names" do
      lambda { client.organizations.create!(name: organization.name) }.should raise_exception(Zendesk2::Error)
      model = client.organizations.create(name: organization.name)
      model.errors.should == {"name" => ["Name: has already been taken"]}
    end
  end
end
