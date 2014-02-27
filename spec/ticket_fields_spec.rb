require 'spec_helper'

describe "ticket_fields" do
  let(:client) { create_client }

  it_should_behave_like "a resource", :ticket_fields,
    lambda { { title: Zendesk2.uuid, type: "text" } },
    lambda { { title: Zendesk2.uuid } }
end
