require 'spec_helper'

describe "categories" do
  let(:client) { create_client }
  it_should_behave_like "a resource",
    :categories,
    lambda { {name: Zendesk2.uuid} },
    lambda { {name: Zendesk2.uuid} }
end
