require 'spec_helper'

describe "help_center/sections" do
  let(:client)   { create_client }
  let!(:category) do
    client.help_center_categories.create!(name: Zendesk2.uuid,
                                          locale: "en-us",
                                         )
  end

  include_examples "zendesk resource", {
    :collection    => lambda { client.help_center_sections },
    :create_params => lambda { { name: Zendesk2.uuid, locale: "en-us", category: category } },
    :update_params => lambda { { name: Zendesk2.uuid } },
    :search        => false,
  }
end
