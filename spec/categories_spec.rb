require 'spec_helper'

describe "categories" do
  let(:client) { create_client }

  include_examples "zendesk resource", {
    :collection    => lambda { client.categories },
    :create_params => lambda { { name: mock_uuid } },
    :update_params => lambda { { name: mock_uuid } },
  }
end
