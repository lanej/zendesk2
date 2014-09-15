require 'spec_helper'

describe "help_center/categories" do
  let(:client)   { create_client }

  include_examples "zendesk resource", {
    :collection    => lambda { client.help_center_categories },
    :create_params => lambda { { name: Zendesk2.uuid, locale: "en-us" } },
    :update_params => lambda { { name: Zendesk2.uuid } },
    :search        => false,
  }
end
