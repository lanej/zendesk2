require 'spec_helper'

describe "tickets" do
  let(:client) { create_client }
  it_should_behave_like "a resource", 
    :tickets,
    lambda { {subject: Zendesk2.uuid, description: Zendesk2.uuid} },
    lambda { {subject: Zendesk2.uuid} }
end
