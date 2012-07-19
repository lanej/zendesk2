require 'spec_helper'

describe "forums" do
  let(:client) { create_client }
  it_should_behave_like "a resource",
    :forums,
    lambda { {name: Zendesk2.uuid} },
    lambda { {name: Zendesk2.uuid} }
end
