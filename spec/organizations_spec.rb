require 'spec_helper'

describe "organizations" do
  let(:client) { create_client }

  include_examples "zendesk#resource", {
    :collection    => lambda { client.organizations },
    :create_params => lambda { { name: mock_uuid } },
    :update_params => lambda { { name: mock_uuid } },
  }

  describe "with an organization" do
    let(:organization) { client.organizations.create!(name: mock_uuid) }

    it "should get #users" do
      user = client.users.create!(email: "#{mock_uuid}@example.org", name: mock_uuid, organization: organization)
      expect(organization.users).to include user
    end

    it "should get #tickets" do
      user = client.users.create!(email: "#{mock_uuid}@example.org", name: mock_uuid, organization: organization)
      ticket = client.tickets.create!(subject: "#{mock_uuid}@example.org", description: mock_uuid, requester: user)
      expect(organization.tickets).to include ticket
    end

    it "should hate non-unique names" do
      # create
      expect {
        client.organizations.create!(name: organization.name)
      }.to raise_exception(Zendesk2::Error)

      expect(
        client.organizations.create(name: organization.name).errors
      ).to eq("name" => ["Name: has already been taken"])

      expect(
        client.organizations.create(name: organization.name.upcase).errors
      ).to eq("name" => ["Name: has already been taken"])

      # update
      model = client.organizations.create!(name: mock_uuid)

      expect(
        model.update(name: organization.name).errors
      ).to eq("name" => ["Name: has already been taken"])

      expect(
        model.update(name: organization.name.upcase).errors
      ).to eq("name" => ["Name: has already been taken"])
    end

    it "should update name" do
      old_name = organization.name
      proxy    = organization.dup
      new_name = mock_uuid

      expect {
        proxy.update!(name: new_name)
      }.to change { organization.reload.name }.from(old_name).to(new_name)
    end

    it "should be able to find organizations by external id" do
      external_id = organization.external_id = mock_uuid
      organization.save!

      expect(client.organizations.find_by_external_id(external_id).first).to eq(organization)
    end
  end
end

describe "#create_organization" do
  let(:client) { create_client }

  it "should prevent duplicate external_ids" do
    external_id = mock_uuid

    client.create_organization("organization" => { "name" => mock_uuid, external_id: nil }) # fine
    client.create_organization("organization" => { "name" => mock_uuid, external_id: nil }) # also fine
    client.create_organization("organization" => { "name" => mock_uuid, external_id: external_id}) # it's cool

    expect {
      client.create_organization("organization" => {"name" => mock_uuid, external_id: external_id})
    }.to raise_exception(Zendesk2::Error, /External has already been taken/)
  end

  it "should correctly respond" do
    body = { "organization" => {"name" => (name = mock_uuid)} }

    response = client.create_organization(body)

    expect(response.status).to eq(201)
    expect(response.env[:url].path).to eq("/api/v2/organizations.json")
    expect(response.env[:method]).to eq(:post)
    expect(client.last_request).to match(body)
    expect(response.env[:body]["organization"]).to match(
      a_hash_including(
        "name" => name,
      ))
  end
end

context "with a organization" do
  let(:client)        { create_client }
  let!(:organization) { client.organizations.create!(name: mock_uuid) }

  describe "#destroy_organization" do
    it "should require a valid organization" do
      expect {
        client.destroy_organization(
          "organization" => {
            "id" => 999999999,
          }
        )
      }.to raise_error(Zendesk2::Error) { |e|
        expect(e.response[:status]).to eq(404)
      }
    end

    it "should correctly respond" do
      response = client.destroy_organization(
        "organization" => {
          "id" => organization.id,
        }
      )

      expect(response.status).to eq(200)
      expect(response.env[:url].path).to eq("/api/v2/organizations/#{organization.id}.json")
      expect(response.env[:method]).to eq(:delete)
      expect(client.last_request).to eq(nil)
      expect(response.env[:body]).to be_falsey
    end
  end

  describe "#get_organizations" do
    it "should correctly respond" do
      response = client.get_organizations

      expect(response.status).to eq(200)
      expect(response.env[:url].path).to eq("/api/v2/organizations.json")
      expect(response.env[:method]).to eq(:get)
      expect(client.last_request).to eq(nil)
      skip unless Zendesk2.mocking?
      expect(response.env[:body]["organizations"]).to match([
        a_hash_including(
          "id"   => organization.id,
        )])
    end
  end

  describe "#get_organization" do
    it "should require a valid organization" do
      expect {
        client.get_organization(
          "organization" => {
            "id" => 999999999,
          }
        )
      }.to raise_error(Zendesk2::Error) { |e|
        expect(e.response[:status]).to eq(404)
      }
    end

    it "should correctly respond" do
      response = client.get_organization(
        "organization" => {
          "id" => organization.id,
        }
      )

      expect(response.status).to eq(200)
      expect(response.env[:url].path).to eq("/api/v2/organizations/#{organization.id}.json")
      expect(response.env[:method]).to eq(:get)
      expect(client.last_request).to eq(nil)
      expect(response.env[:body]["organization"]).to match(
        a_hash_including(
          "id"   => organization.id,
          "url"  => response.env[:url].to_s,
        ))
    end
  end

  describe "#update_organization" do
    it "should require a valid organization" do
      expect {
        client.update_organization(
          "organization" => {
            "id"   => 999999999,
            "name" => mock_uuid,
          }
        )
      }.to raise_error(Zendesk2::Error) { |e|
        expect(e.response[:status]).to eq(404)
      }
    end

    it "should prevent duplicate external_ids" do
      external_id = mock_uuid

      organization         = client.organizations.create!(name: mock_uuid)
      another_organization = client.organizations.create!(name: mock_uuid)

      client.update_organization("organization" => {"id" => organization.id, external_id: nil}) # fine
      client.update_organization("organization" => {"id" => another_organization.id, external_id: external_id}) # also fine

      expect {
        client.update_organization("organization" => {"id" => organization.id, external_id: external_id})
      }.to raise_exception(Zendesk2::Error, /External has already been taken/)
    end

    it "should correctly respond" do
      response = client.update_organization(
        "organization" => {
          "id"   => organization.id,
          "name" => (name = mock_uuid),
        }
      )

      expect(response.status).to eq(200)
      expect(response.env[:url].path).to eq("/api/v2/organizations/#{organization.id}.json")
      expect(response.env[:method]).to eq(:put)
      expect(client.last_request).to eq("organization" => {"name" => name})
      expect(response.env[:body]["organization"]).to match(
        a_hash_including(
          "id"   => organization.id,
          "url"  => response.env[:url].to_s,
          "name" => name,
        ))
    end
  end
end
