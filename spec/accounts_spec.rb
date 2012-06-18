require 'spec_helper'
require 'logger'

describe "accounts" do
  let(:client) { create_client }
  it_should_behave_like "a resource", 
    :accounts,
    lambda { {name: "Roger#{rand(100_000_000)}"} },
    lambda { {name: "Rogerito"} }
end
