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
end
