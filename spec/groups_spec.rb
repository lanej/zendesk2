require 'spec_helper'

describe "groups" do
  let(:client) { create_client }
  it_should_behave_like "a resource", :groups,
    lambda { {name: Zendesk2.uuid} },
    lambda { {name: Zendesk2.uuid} }

  it "should list assignable groups" do
    client.groups.create(name: Zendesk2.uuid) # assignable by default

    client.groups.assignable.should be_all{|g| !g.deleted}
  end
end
