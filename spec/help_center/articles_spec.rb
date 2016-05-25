require 'spec_helper'

describe "help_center/articles" do
  let(:client)   { create_client }
  let!(:section) do
    category = client.help_center_categories.create!(name: mock_uuid,
                                                     locale: "en-us",
                                                    )
    client.help_center_sections.create!(:name     => mock_uuid,
                                        :locale   => "en-us",
                                        :category => category,
                                       )
  end

  include_examples "zendesk#resource", {
    :collection    => lambda { client.help_center_articles },
    :create_params => lambda { { title: mock_uuid, locale: "en-us", section: section } },
    :update_params => lambda { { title: mock_uuid } },
    :search_params => lambda { Cistern::Hash.slice(create_params, :title) },
    :search        => true,
  }

  describe "translations" do
    let!(:article) do
      client.help_center_articles.create!(:title    => mock_uuid,
                                          :locale   => "en-us",
                                          :section  => section
                                          )
    end
    let!(:locale) { mock_uuid }

    include_examples "zendesk#resource", {
      :collection     => lambda { article.translations },
      :fetch_params   => lambda { |r| Cistern::Hash.slice(r.attributes, :source_id, :source_type, :locale) },
      :create_params  => lambda { { source: article, locale: locale, title: mock_uuid } },
      :update_params  => lambda { { title: mock_uuid } },
      :search         => false
    }
  end
end
