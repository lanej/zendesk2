require 'spec_helper'

describe "help_center/articles" do
  let(:client) { create_client }

  include_examples "zendesk resource", {
    :collection      => lambda { client.help_center_articles },
    :create_params   => lambda { { name: Zendesk2.uuid } },
    :update_params   => lambda { { name: Zendesk2.uuid } },
    :delayed_destroy => true,
  }
end
