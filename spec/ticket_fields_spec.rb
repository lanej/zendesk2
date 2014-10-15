require 'spec_helper'

describe "ticket_fields" do
  let(:client) { create_client }

  include_examples "zendesk resource", {
    :collection    => lambda { client.ticket_fields },
    :create_params => lambda { { title: mock_uuid, type: "text" } },
    :update_params => lambda { { title: mock_uuid } },
    :paged         => false,
  }
end
