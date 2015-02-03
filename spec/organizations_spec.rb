require 'spec_helper'

describe "organizations" do
  let(:client) { create_client }

  include_examples "zendesk resource", {
    :collection    => lambda { client.organizations },
    :create_params => lambda { { name: mock_uuid } },
    :update_params => lambda { { name: mock_uuid } },
  }

  describe "with an organization" do
    let(:organization) { client.organizations.create!(name: mock_uuid) }

    it "should get #users" do
      user = client.users.create(email: "#{mock_uuid}@example.org", name: mock_uuid, organization: organization)
      expect(organization.users).to include user
    end

    it "should get #tickets" do
      user = client.users.create(email: "#{mock_uuid}@example.org", name: mock_uuid, organization: organization)
      ticket = client.tickets.create(subject: "#{mock_uuid}@example.org", description: mock_uuid, requester: user)
      expect(organization.tickets).to include ticket
    end

    it "should hate non-unique names" do
      expect { client.organizations.create!(name: organization.name) }.to raise_exception(Zendesk2::Error)
      model = client.organizations.create(name: organization.name)
      expect(model.errors).to eq({"name" => ["Name: has already been taken"]})
      model = client.organizations.create(name: mock_uuid)
      model.name = organization.name
      model.save
      expect(model.errors).to eq({"name" => ["Name: has already been taken"]})
    end

    it "should update name" do
      old_name = organization.name
      proxy = organization.dup
      new_name = proxy.name = mock_uuid

      expect {
        proxy.save!
      }.to change { organization.reload.name }.from(old_name).to(new_name)
    end

    it "should be able to find organizations by external id" do
      external_id = organization.external_id = mock_uuid
      organization.save!

      expect(client.organizations.find_by_external_id(external_id).first).to eq(organization)
    end
  end

  describe "#create_organization" do
    it "should prevent duplicate external_ids" do
      client.create_organization("name" => "a", external_id: nil) # fine
      client.create_organization("name" => "b", external_id: nil) # also fine
      client.create_organization("name" => "c", external_id: "1") # it's cool

      expect {
        client.create_organization("name" => "d", external_id: "1")
      }.to raise_exception(Zendesk2::Error, /External has already been taken/)
    end
  end

  describe "#update_organization" do
    it "should prevent duplicate external_ids" do
      organization         = client.organizations.create(name: "a")
      another_organization = client.organizations.create(name: "b")

      client.update_organization("id" => organization.id, external_id: nil) # fine
      client.update_organization("id" => another_organization.id, external_id: "1") # also fine

      expect {
        client.update_organization("id" => organization.id, external_id: "1")
      }.to raise_exception(Zendesk2::Error, /External has already been taken/)
    end
  end
end
