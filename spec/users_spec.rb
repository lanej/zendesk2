require 'spec_helper'
require 'logger'

describe "users" do
  let(:client) { create_client }
  it_should_behave_like "a collection", :users
  it_should_behave_like "a model", :user

  it "should get current user" do
    current_user = client.users.current
    current_user.should be_a(Zendesk::Client::User)
    current_user.email.should == client.username
  end
end
