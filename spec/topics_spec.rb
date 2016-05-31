# frozen_string_literal: true
require 'spec_helper'

describe 'topics' do
  let(:client) { create_client }
  let(:forum)  { client.forums.create(name: mock_uuid) }

  include_examples 'zendesk#resource', collection: -> { client.topics },
                                       create_params: -> { { title: mock_uuid, body: mock_uuid, forum_id: forum.id } },
                                       update_params: -> { { title: mock_uuid, body: mock_uuid } }
end
