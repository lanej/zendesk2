require 'spec_helper'

describe "organizations" do
  let(:client) { create_client }
  it_should_behave_like "a resource",
    :organizations,
    lambda { {name: Zendesk2.uuid} },
    lambda { {name: Zendesk2.uuid} }
end
