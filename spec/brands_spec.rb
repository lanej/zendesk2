# frozen_string_literal: true
require 'spec_helper'

describe 'brands' do
  let(:client) { create_client }

  include_examples 'zendesk#resource', collection: -> { client.brands },
                                       create_params: -> { { name: mock_uuid } },
                                       update_params: -> { { name: mock_uuid } },
                                       paged: false,
                                       search: false
end
