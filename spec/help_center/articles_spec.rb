require 'spec_helper'

describe "help_center/articles" do
  let(:client)   { create_client }
  let!(:section) do
    category = client.help_center_categories.create!(name: Zendesk2.uuid,
                                                     locale: "en-us",
                                                    )
    client.help_center_sections.create!(:name     => Zendesk2.uuid,
                                        :locale   => "en-us",
                                        :category => category,
                                       )
  end

  include_examples "zendesk resource", {
    :collection    => lambda { client.help_center_articles },
    :create_params => lambda { { title: Zendesk2.uuid, locale: "en", section: section } },
    :update_params => lambda { { title: Zendesk2.uuid } },
    :search        => false,
  }
end
