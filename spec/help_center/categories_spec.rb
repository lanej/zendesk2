# frozen_string_literal: true
require 'spec_helper'

describe 'help_center/categories' do
  let(:client) { create_client }

  include_examples 'zendesk#resource',
                   collection: -> { client.help_center_categories(locale: 'en-us') },
                   create_params: -> { { name: mock_uuid, locale: 'en-us' } },
                   update_params: -> { { name: mock_uuid } },
                   search: false

  context 'with a category, sections, and articles' do
    let!(:category) { client.help_center_categories.create!(name: mock_uuid, locale: 'en-us') }
    let!(:section)  { category.sections.create!(name: mock_uuid, locale: 'en-us') }
    let!(:articles) { Array.new(2) { section.articles.create(title: mock_uuid, locale: 'en-us', permission_group_id: 0) } }

    before do
      client.help_center_categories.create!(name: mock_uuid, locale: 'en-us')
            .sections.create!(name: mock_uuid, locale: 'en-us').articles.create!(title: mock_uuid, locale: 'en-us', permission_group_id: 0)
    end

    it 'lists sections within a category' do
      expect(category.sections.all).to contain_exactly(section)
    end

    it 'lists articles within a category' do
      expect(category.articles.all).to match_array(articles)
    end
  end
end
