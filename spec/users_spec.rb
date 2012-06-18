require 'spec_helper'

describe "users" do
  let(:client) { create_client }
  it_should_behave_like "a resource", 
    :users,
    lambda { {email: "zendesk2+#{rand(100_000_000)}@example.org", name: "Roger Wilco", verified: true} },
    lambda { {name: "Rogerito Wilcinzo"} }

  it "should get current user" do
    current_user = client.users.current
    current_user.should be_a(Zendesk2::Client::User)
    current_user.email.should == client.username
  end
end
