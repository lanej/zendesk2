require 'spec_helper'

describe "forums" do
  let(:client) { create_client }

  include_examples "zendesk resource", {
    :collection      => lambda { client.forums },
    :create_params   => lambda { { name: Zendesk2.uuid } },
    :update_params   => lambda { { name: Zendesk2.uuid } },
    :delayed_destroy => true,
  }
end
