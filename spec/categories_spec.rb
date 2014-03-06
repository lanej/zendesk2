require 'spec_helper'

describe "categories" do
  let(:client) { create_client }

  include_examples "zendesk resource", {
    :collection    => lambda { client.categories },
    :create_params => lambda { { name: Zendesk2.uuid } },
    :update_params => lambda { { name: Zendesk2.uuid } },
  }
end
