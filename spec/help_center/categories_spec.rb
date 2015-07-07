require 'spec_helper'

describe "help_center/categories" do
  let(:client)   { create_client }

  include_examples "zendesk resource", {
    :collection    => lambda { client.help_center_categories },
    :create_params => lambda { { name: mock_uuid, locale: "en-us" } },
    :update_params => lambda { { name: mock_uuid } },
    :search        => false,
  }

  context "with a category and some related sections" do
    let!(:category) { client.help_center_categories.create!(name: mock_uuid, locale: "en-us") }

    let!(:sections) { 2.times.map { category.sections.create!(name: mock_uuid, locale: "en-us") } }

    before { client.help_center_categories.create!(name: mock_uuid, locale: "en-us").sections.create!(name: mock_uuid, locale: "en-us") }

    it "lists sections within a category" do
      expect(category.sections.all).to match_array(sections)
    end
  end
end
