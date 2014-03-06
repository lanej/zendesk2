require 'spec_helper'

describe "groups" do
  let(:client) { create_client }

  include_examples "zendesk resource", {
    :collection    => lambda { client.groups },
    :create_params => lambda { { name: Zendesk2.uuid } },
    :update_params => lambda { { name: Zendesk2.uuid } },
  }

  it "should list assignable groups" do
    client.groups.create(name: Zendesk2.uuid) # assignable by default

    client.groups.assignable.should be_all{|g| !g.deleted}
  end
end
