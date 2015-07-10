require 'spec_helper'

describe "topics" do
  let(:client) { create_client }
  let(:forum)  { client.forums.create(name: mock_uuid) }

  include_examples "zendesk#resource", {
    :collection    => lambda { client.topics },
    :create_params => lambda { { title: mock_uuid, body: mock_uuid, forum_id: forum.id } },
    :update_params => lambda { { title: mock_uuid, body: mock_uuid } },
  }
end
