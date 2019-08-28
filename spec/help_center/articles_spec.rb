# frozen_string_literal: true
require 'spec_helper'

describe 'help_center/articles' do
  let(:client)   { create_client }
  let!(:section) do
    category = client.help_center_categories.create!(name: mock_uuid,
                                                     locale: 'en-us')
    client.help_center_sections.create!(name: mock_uuid,
                                        locale: 'en-us',
                                        category: category)
  end

  include_examples 'zendesk#resource',
                   collection: -> { client.help_center_articles },
                   create_params:
                     -> { { title: mock_uuid, locale: 'en-us', section: section, permission_group_id: 0 } },
                   update_params: -> { { title: mock_uuid } },
                   search_params: -> { Cistern::Hash.slice(create_params, :title) },
                   search: true
end
