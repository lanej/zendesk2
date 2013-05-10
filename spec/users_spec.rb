require 'spec_helper'

describe "users" do
  let(:client) { create_client }
  it_should_behave_like "a resource", :users,
    lambda { {email: "zendesk2+#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, verified: true} },
  lambda { {name: Zendesk2.uuid} }

  it "should get current user" do
    current_user = client.users.current
    current_user.email.should == client.username
  end

  describe do
    before(:each) do
      @user = client.users.create!(email: "zendesk2+#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid)
    end

    let(:user) { @user }

    it "should update organization" do
      organization = client.organizations.create(name: Zendesk2.uuid)
      user.organization= organization
      user.save.should be_true
      user.organization.should == organization
    end

    it "should get requested tickets" do
      ticket = client.tickets.create(requester: user, subject: Zendesk2.uuid, description: Zendesk2.uuid)

      user.requested_tickets.should include ticket
    end

    it "should get ccd tickets" do
      ticket = client.tickets.create(collaborators: [user], subject: Zendesk2.uuid, description: Zendesk2.uuid)

      user.ccd_tickets.should include ticket
    end

    it "cannot destroy a user with a ticket" do
      ticket = client.tickets.create(requester: user, subject: Zendesk2.uuid, description: Zendesk2.uuid)

      user.destroy.should be_false

      user.should_not be_destroyed
    end

    it "should list identities" do
      identities = user.identities.all
      identities.size.should == 1

      identity = identities.first
      identity.primary.should be_true
      identity.verified.should be_false
      identity.type.should == "email"
      identity.value.should == user.email
    end

    it "should create a new identity" do
      email = "ey+#{Zendesk2.uuid}@example.org"

      new_identity = user.identities.create!(type: "email", value: email)
      new_identity.primary.should be_false
      new_identity.verified.should be_false
      new_identity.type.should == "email"
      new_identity.value.should == email
    end

    it "should mark remaining identity as primary" do
      email = "ey+#{Zendesk2.uuid}@example.org"

      initial_identity = user.identities.all.first
      new_identity     = user.identities.create!(type: "email", value: email)

      initial_identity.destroy

      new_identity.reload.primary.should be_false

      new_identity.primary!
      new_identity.reload.primary.should be_true
    end

    it "should not allow multiple primary identities" do
      email = "ey+#{Zendesk2.uuid}@example.org"

      initial_identity = user.identities.all.first
      new_identity     = user.identities.create!(type: "email", value: email)
      new_identity.primary!
      new_identity.primary.should be_true
      new_identity.reload.primary.should be_true

      initial_identity.reload.primary.should be_false
    end

    it "should hate non-unique emails" do
      email = "zendesk2+#{Zendesk2.uuid}@example.org"
      client.users.create(email: email, name: Zendesk2.uuid)
      lambda { client.users.create!(email: email, name: Zendesk2.uuid) }.should raise_exception(Zendesk2::Error)
      user = client.users.create(email: email, name: Zendesk2.uuid)
      user.identity.should be_false
      user.errors.should == {"email" => ["Email #{email} is already being used by another user"]}
    end

    it "should create another identity when updating email" do
      original_email = user.email
      user.email = (new_email = "zendesk2+#{Zendesk2.uuid}@example.org")
      user.save!

      (identities = user.identities.all).size.should == 2
      new_identity = identities.find{|i| i.value == new_email}
      new_identity.should_not be_nil

      new_identity.primary.should be_false

      original_identity = identities.find{|i| i.value == original_email}
      original_identity.should_not be_nil

      original_identity.primary.should be_true

      user.reload.email.should == original_email
    end

    it "should form 'legacy' login url" do
      return_to = "http://engineyard.com"
      uri = Addressable::URI.parse(user.login_url(Time.now.to_s, return_to: return_to, token: "in-case-you-dont-have-it-in ~/.zendesk2 (aka ci)"))
      uri.query_values["return_to"].should == return_to
      uri.query_values["name"].should eq user.name
      uri.query_values["email"].should eq user.email
      uri.query_values["hash"].should_not be_nil
    end

    it "should form jwt login url" do
      return_to = "http://engineyard.com"
      uri = Addressable::URI.parse(user.jwt_login_url(return_to: return_to, jwt_token: "in-case-you-dont-have-it-in ~/.zendesk2 (aka ci)"))
      uri.query_values["return_to"].should == return_to
      uri.query_values["name"].should be_nil
      uri.query_values["email"].should be_nil
      uri.query_values["jwt"].should_not be_nil

      #TODO: try JWT.decode
    end

  end
end
