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
    let!(:articles) { Array.new(2) { section.articles.create(title: mock_uuid, locale: 'en-us') } }

    before do
      client.help_center_categories.create!(name: mock_uuid, locale: 'en-us')
            .sections.create!(name: mock_uuid, locale: 'en-us').articles.create!(title: mock_uuid, locale: 'en-us')
    end

    it 'lists sections within a category' do
      expect(category.sections.all).to contain_exactly(section)
    end

    it 'lists articles within a category' do
      expect(category.articles.all).to match_array(articles)
    end
  end

  describe 'translations' do
    let!(:category) { client.help_center_categories.create!(name: mock_uuid, locale: 'en-us') }
    let!(:locale) { mock_uuid }

    include_examples 'zendesk#resource',
                     collection: -> { category.translations },
                     fetch_params: ->(r) { Cistern::Hash.slice(r.attributes, :source_id, :source_type, :locale) },
                     create_params: -> { { source: category, locale: locale, title: mock_uuid } },
                     update_params: -> { { title: mock_uuid } },
                     search: false
  end
end
