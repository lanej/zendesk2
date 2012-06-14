require 'spec_helper'

describe "users" do
  let(:client) { Zendesk::Client.new }
  it_should_behave_like "a collection", :users
  it_should_behave_like "a model", :user
end
