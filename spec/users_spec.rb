require 'spec_helper'

describe "users" do
  let(:client) { create_client }
  it_should_behave_like "a resource", 
    :users,
    lambda { {email: "zendesk2+#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, verified: true} },
  lambda { {name: Zendesk2.uuid} }

  it "should get current user" do
    current_user = client.users.current
    current_user.should be_a(Zendesk2::Client::User)
    current_user.email.should == client.username
  end

  it "should find users by email" do
    current_user = client.users.current
    user = client.users.search_by_email(current_user.email)
    user.email.should == current_user.email
  end

  describe do
    before(:each) do
      @user =  client.users.create(email: "zendesk2+#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid)
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

    it "should hate non-unique emails" do
      email = "zendesk2+#{Zendesk2.uuid}@example.org"
      client.users.create(email: email, name: Zendesk2.uuid)
      lambda { client.users.create!(email: email, name: Zendesk2.uuid) }.should raise_exception(Zendesk2::Error)
      user = client.users.create(email: email, name: Zendesk2.uuid)
      user.identity.should be_false
      user.errors.should == {"email" => ["Email: #{email} is already being used by another user"]}
    end

    it "should form login url" do
      return_to = "http://engineyard.com"
      uri = Addressable::URI.parse(user.login_url(Time.now.to_s, return_to: return_to))
      uri.query_values["return_to"].should == return_to
    end
  end
end
