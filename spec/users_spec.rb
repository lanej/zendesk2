require 'spec_helper'

describe "users" do
  let(:client) { create_client }

  include_examples "zendesk#resource", {
    :collection    => lambda { client.users },
    :create_params => lambda { { email: mock_email, name: mock_uuid, verified: true } },
    :update_params => lambda { { name: mock_uuid } },
  }

  it "should get current user" do
    current_user = client.users.current
    expect(current_user.email).to eq(client.username)
  end

  describe "#create_user" do
    it "should prevent duplicate external_ids" do
      external_id = mock_uuid

      client.create_user("user" => {:email => mock_email, :name => "a", :external_id => nil})         # fine
      client.create_user("user" => {:email => mock_email, :name => "b", :external_id => nil})         # also fine
      client.create_user("user" => {:email => mock_email, :name => "c", :external_id => external_id}) # it's cool

      expect {
        client.create_user("user" => {:email => mock_email, :name => "d", :external_id => external_id})
      }.to raise_exception(Zendesk2::Error, /External has already been taken/)
    end
  end

  describe "#update_user" do
    it "should prevent duplicate external_ids" do
      user         = client.users.create(email: mock_email, name: "a")
      another_user = client.users.create(email: mock_email, name: "b")

      external_id = mock_uuid

      client.update_user("user" => {"id" => user.id,         "external_id" => nil})         # fine
      client.update_user("user" => {"id" => another_user.id, "external_id" => external_id}) # also fine

      expect {
        client.update_user("user" => {"id" => user.id, "external_id" => external_id})
      }.to raise_exception(Zendesk2::Error, /External has already been taken/)
    end
  end

  describe "#search", :mock_only do
    it "should find a user based on details criteria with wildcards and by organization name" do
      # detached user
      client.users.create!(email: mock_email, name: mock_uuid)

      # possible match
      bad_org = client.organizations.create!(name: mock_uuid)
      client.users.create!(email: mock_email, name: mock_uuid, organization: bad_org)

      org = client.organizations.create!(name: mock_uuid)
      user = client.users.create!(email: mock_email, name: mock_uuid, organization: org, details: "anything_hello-something-michelle")

      expect(client.users.search(details: "*michelle*", organization: org.name)).to contain_exactly(user)
      expect(client.users.search(details: "*michelle*", organization: org.name[0..6])).to include(user)
    end

    context "when a user has multiple identities and searching by email" do
      it "should display the primary email in the results" do
        user = client.users.create!(email: (primary = mock_email), name: mock_uuid)

        # create some extra identities
        user.identities.create!(value: mock_email, type: "email")
        user.identities.create!(value: (target = mock_email), type: "email")

        # primary email should be returned in the results
        expect(client.users.search(email: target).first.email).to eq(primary)
      end
    end
  end

  context "with a user" do
    let!(:user) { client.users.create!(email: mock_email, name: mock_uuid) }

    describe "#save" do
      it "should update organization" do
        user.organization = organization = client.organizations.create!(name: mock_uuid)

        user.save!

        expect(user.organization).to eq(organization)
      end
    end

    it "should get requested tickets" do
      another_user = client.users.create!(email: mock_email, name: mock_uuid)

      2.times.each {
        another_user.tickets.create!(collaborators: [user], subject: mock_uuid, description: mock_uuid)
      }

      targets = 2.times.map {
        user.tickets.create!(requester: user, subject: mock_uuid, description: mock_uuid)
      }

      expect(user.requested_tickets.all(per_page: 1).all_entries).to match_array(targets)
    end

    it "should get ccd tickets", mock_only: true do
      ticket = client.tickets.create!(collaborators: [user], subject: mock_uuid, description: mock_uuid)

      expect(user.ccd_tickets).to contain_exactly(ticket)
    end

    it "cannot destroy a user with a ticket" do
      client.tickets.create!(requester: user, subject: mock_uuid, description: mock_uuid)

      expect(user.destroy).to be_falsey

      expect(user).not_to be_destroyed
    end

    it "should list identities" do
      identities = user.identities.all
      expect(identities.size).to eq(1)

      identity = identities.first
      expect(identity.primary).to be_truthy
      expect(identity.verified).to be_falsey
      expect(identity.type).to eq("email")
      expect(identity.value).to eq(user.email)
    end

    it "should create a new identity" do
      email = "ey+#{mock_uuid}@example.org"

      new_identity = user.identities.create!(type: "email", value: email)

      expect(new_identity.primary).to be_falsey
      expect(new_identity.verified).to be_falsey
      expect(new_identity.type).to eq("email")
      expect(new_identity.value).to eq(email)
    end

    it "should mark remaining identity as primary" do
      email = "ey+#{mock_uuid}@example.org"

      initial_identity = user.identities.all.first
      new_identity     = user.identities.create!(type: "email", value: email)

      expect {
        initial_identity.destroy
      }.to change { user.identities.all }.
      from(a_collection_containing_exactly(initial_identity, new_identity)).
      to(a_collection_containing_exactly(new_identity))

      expect(new_identity.reload.primary).to be_falsey

      new_identity.primary!

      expect(new_identity.reload.primary).to be_truthy
    end

    it "should not allow multiple primary identities" do
      email = "ey+#{mock_uuid}@example.org"

      initial_identity = user.identities.all.first
      new_identity     = user.identities.create!(type: "email", value: email)
      new_identity.primary!
      expect(new_identity.primary).to be_truthy
      expect(new_identity.reload.primary).to be_truthy

      expect(initial_identity.reload.primary).to be_falsey
    end

    it "should hate non-unique emails" do
      email = mock_email
      client.users.create!(email: email, name: mock_uuid)
      expect { client.users.create!(email: email, name: mock_uuid) }.to raise_exception(Zendesk2::Error)

      user = client.users.create(email: email, name: mock_uuid)

      expect(user.identity).to eq(nil)
      expect(user.errors).to eq({"email" => ["Email: #{email} is already being used by another user"]})
    end

    it "should create another identity when updating email" do
      original_email = user.email
      user.email = (new_email = mock_email)

      expect {
        user.save!
      }.to change { user.identities.size }.from(1).to(2)

      new_identity = user.identities.find { |i| i.value == new_email }

      expect(new_identity).to be
      expect(new_identity.primary).to eq(false)

      original_identity = user.identities.find { |i| i.value == original_email }

      expect(original_identity).to be
      expect(original_identity.primary).to eq(true)
      expect(user.reload.email).to eq(original_email)

      expect {
        user.save!
      }.not_to change { user.identities.size }
    end

    it "should form 'legacy' login url" do
      return_to = "http://engineyard.com"
      login_uri = user.login_url(Time.now.to_s, return_to: return_to, token: "in-case-you-dont-have-it-in ~/.zendesk2 (aka ci)")
      query = Faraday::NestedParamsEncoder.decode(URI.parse(login_uri).query)

      expect(query["return_to"]).to eq(return_to)
      expect(query["name"]).to eq user.name
      expect(query["email"]).to eq user.email
      expect(query["hash"]).not_to be_nil
    end

    it "should form jwt login url" do
      return_to = "http://engineyard.com"

      jwt_login_uri = user.jwt_login_url(return_to: return_to, jwt_token: "in-case-you-dont-have-it-in ~/.zendesk2 (aka ci)")
      query = Faraday::NestedParamsEncoder.decode(URI.parse(jwt_login_uri).query)

      expect(query["return_to"]).to eq(return_to)
      expect(query["name"]).to be_nil
      expect(query["email"]).to be_nil
      expect(query["jwt"]).not_to be_nil
    end
  end
end
