require 'spec_helper'

describe "organizations" do
  let(:client) { create_client }
  it_should_behave_like "a resource",
    :organizations,
    lambda { {name: "Roger#{rand(100_000_000)}"} },
    lambda { {name: "Rogerito"} }
end
