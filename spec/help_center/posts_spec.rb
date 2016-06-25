# frozen_string_literal: true
require 'spec_helper'

describe 'help_center/posts' do
  let(:client) { create_client }
  let!(:topic) { client.help_center_topics.create(name: mock_uuid) }

  include_examples 'zendesk#resource',
                   collection: -> { topic.posts },
                   create_params: -> { { title: mock_uuid, details: mock_uuid } },
                   destroy: false,
                   update: false,
                   search: false
end
