require 'spec_helper'

describe "accounts" do
  let(:client) { Zendesk::Client.new }
  it_should_behave_like "a collection", :accounts
  it_should_behave_like "a model", :account
end
