# frozen_string_literal: true
require 'spec_helper'

describe 'ticket_forms' do
  let(:client) { create_client }

  include_examples 'zendesk#resource', collection: -> { client.ticket_forms },
                                       create_params: -> { { name: mock_uuid } },
                                       update_params: -> { { name: mock_uuid } },
                                       paged: false
end
