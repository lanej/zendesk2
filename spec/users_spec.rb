require 'spec_helper'
require 'logger'

describe "users" do
  let(:client) { create_client }
  it_should_behave_like "a collection", :users, lambda { {email: "zendesk2+#{rand(100_000_000)}@example.org", name: "Roger Wilco", verified: true} }
  it_should_behave_like "a model"

  it "should get current user" do
    current_user = client.users.current
    current_user.should be_a(Zendesk::Client::User)
    current_user.email.should == client.username
  end
end
