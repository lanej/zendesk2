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

  describe do
    let(:user) { client.users.create(email: "zendesk2+#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid) }

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

    it "should form login url"
  end
end
