require 'spec_helper'

describe "help_center/sections" do
  let(:client)   { create_client }
  let!(:category) do
    client.help_center_categories.create!(
      name: mock_uuid,
      locale: "en-us",
    )
  end

  include_examples "zendesk#resource", {
    :collection    => lambda { client.help_center_sections },
    :create_params => lambda { { name: mock_uuid, locale: "en-us", category: category } },
    :update_params => lambda { { name: mock_uuid } },
    :search        => false,
  }

  context "with a category, sections, and articles" do
    let!(:category) { client.help_center_categories.create!(name: mock_uuid, locale: "en-us") }
    let!(:section)  { category.sections.create!(name: mock_uuid, locale: "en-us") }
    let!(:articles) { 2.times.map { section.articles.create(title: mock_uuid, locale: "en-us") } }

    before {
      client.help_center_categories.create!(name: mock_uuid, locale: "en-us").
      sections.create!(name: mock_uuid, locale: "en-us").articles.create!(title: mock_uuid, locale: "en-us")
    }

    it "lists articles within a section" do
      expect(section.articles.all).to match_array(articles)
    end

    it "shows the access policy for the section" do
      expect(section.access_policy.viewable_by).to eq("everyone")
    end

    it "updates the section access policy" do
      policy = section.access_policy
      old_viewable_by = policy.viewable_by
      new_viewable_by = "staff"

      expect {
        policy.update!(viewable_by: new_viewable_by)
      }.to change { section.reload.access_policy.viewable_by }.from(old_viewable_by).to(new_viewable_by)
    end
  end
end
