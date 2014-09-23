require 'spec_helper'

describe "organizations" do
  let(:client) { create_client }

  include_examples "zendesk resource", {
    :collection    => lambda { client.organizations },
    :create_params => lambda { { name: Zendesk2.uuid } },
    :update_params => lambda { { name: Zendesk2.uuid } },
  }

  describe "with an organization" do
    let(:organization) { client.organizations.create!(name: Zendesk2.uuid) }

    it "should get #users" do
      user = client.users.create(email: "#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, organization: organization)
      expect(organization.users).to include user
    end

    it "should get #tickets" do
      user = client.users.create(email: "#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, organization: organization)
      ticket = client.tickets.create(subject: "#{Zendesk2.uuid}@example.org", description: Zendesk2.uuid, requester: user)
      expect(organization.tickets).to include ticket
    end

    it "should hate non-unique names" do
      expect { client.organizations.create!(name: organization.name) }.to raise_exception(Zendesk2::Error)
      model = client.organizations.create(name: organization.name)
      expect(model.errors).to eq({"name" => ["Name: has already been taken"]})
      model = client.organizations.create(name: Zendesk2.uuid)
      model.name = organization.name
      model.save
      expect(model.errors).to eq({"name" => ["Name: has already been taken"]})
    end

    it "should be able to find organizations by external id" do
      external_id = organization.external_id = Zendesk2.uuid
      organization.save!

      expect(client.organizations.find_by_external_id(external_id).first).to eq(organization)
    end

  end
end
