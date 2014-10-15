require 'spec_helper'

describe "forums" do
  let(:client) { create_client }

  include_examples "zendesk resource", {
    :collection      => lambda { client.forums },
    :create_params   => lambda { { name: mock_uuid } },
    :update_params   => lambda { { name: mock_uuid } },
    :delayed_destroy => true,
  }
end
