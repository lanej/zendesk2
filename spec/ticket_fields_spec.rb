require 'spec_helper'

describe "ticket_fields" do
  let(:client) { create_client }

  include_examples "zendesk resource", {
    :collection    => lambda { client.ticket_fields },
    :create_params => lambda { { title: Zendesk2.uuid, type: "text" } },
    :update_params => lambda { { title: Zendesk2.uuid } },
    :paged         => false,
  }
end
