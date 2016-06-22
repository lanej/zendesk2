# frozen_string_literal: true
require 'spec_helper'

describe 'help_center/translations' do
  let(:client) { create_client }
  let!(:category) { client.help_center_categories.create!(name: mock_uuid, locale: 'en-us') }
  let!(:locale) { mock_uuid }

  include_examples 'zendesk#resource',
                   collection: -> { category.translations },
                   fetch_params: ->(r) { Cistern::Hash.slice(r.attributes, :source_id, :source_type, :locale) },
                   create_params: -> { { source: category, locale: locale, title: mock_uuid } },
                   update_params: -> { { title: mock_uuid } },
                   search: false
end
