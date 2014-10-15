require 'spec_helper'

describe "groups" do
  let(:client) { create_client }

  include_examples "zendesk resource", {
    :collection    => lambda { client.groups },
    :create_params => lambda { { name: mock_uuid } },
    :update_params => lambda { { name: mock_uuid } },
  }

  it "should list assignable groups" do
    client.groups.create(name: mock_uuid) # assignable by default

    expect(client.groups.assignable).to be_all{|g| !g.deleted}
  end
end
