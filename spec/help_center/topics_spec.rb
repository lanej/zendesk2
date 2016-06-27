# frozen_string_literal: true
require 'spec_helper'

describe 'help_center/topics' do
  let(:client) { create_client }

  include_examples 'zendesk#resource',
                   collection: -> { client.help_center_topics },
                   create_params: -> { { name: mock_uuid } },
                   update_params: -> { { name: mock_uuid } },
                   search: false,
                   paged: false
end
