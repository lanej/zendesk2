# frozen_string_literal: true
require 'spec_helper'

describe 'help_center/translations' do
  let(:client) { create_client }
  let!(:locale) { mock_uuid }
  let!(:category) { client.help_center_categories.create!(name: mock_uuid, locale: 'en-us') }

  let(:section) { category.sections.create!(name: mock_uuid, locale: 'en-us') }

  describe 'by category' do
    include_examples 'zendesk#resource',
                     collection: -> { category.translations },
                     fetch_params: ->(r) { Cistern::Hash.slice(r.attributes, :source_id, :source_type, :locale) },
                     create_params: -> { { source: category, locale: locale, title: mock_uuid } },
                     update_params: -> { { title: mock_uuid } },
                     search: false
  end

  describe 'by section' do
    before { section }

    include_examples 'zendesk#resource',
                     collection: -> { section.translations },
                     fetch_params: ->(r) { Cistern::Hash.slice(r.attributes, :source_id, :source_type, :locale) },
                     create_params: -> { { source: section, locale: locale, title: mock_uuid } },
                     update_params: -> { { title: mock_uuid } },
                     search: false
  end

  describe 'by article' do
    let!(:article) { client.help_center_articles.create!(title: mock_uuid, locale: 'en-us', section: section) }

    include_examples 'zendesk#resource',
                     collection: -> { article.translations },
                     fetch_params: ->(r) { Cistern::Hash.slice(r.attributes, :source_id, :source_type, :locale) },
                     create_params: -> { { source: article, locale: locale, title: mock_uuid } },
                     update_params: -> { { title: mock_uuid } },
                     search: false
  end
end
