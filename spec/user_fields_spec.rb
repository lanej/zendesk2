# frozen_string_literal: true
require 'spec_helper'

describe 'user_fields' do
  let(:client) { create_client }

  include_examples 'zendesk#resource',
                   collection: -> { client.user_fields },
                   create_params: -> { { title: mock_uuid, type: 'text', key: "custom_#{SecureRandom.hex(3)}" } },
                   update_params: -> { { title: mock_uuid } },
                   paged: false
end
