# frozen_string_literal: true
require 'spec_helper'

describe 'ticket_fields' do
  let(:client) { create_client }

  include_examples 'zendesk#resource', collection: -> { client.ticket_fields },
                                       create_params: -> { { title: mock_uuid, type: 'text' } },
                                       update_params: -> { { title: mock_uuid } },
                                       paged: false
end
