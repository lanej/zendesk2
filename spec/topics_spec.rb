require 'spec_helper'

describe "topics" do
  let(:client) { create_client }
  let(:forum)  { client.forums.create(name: Zendesk2.uuid) }

  include_examples "zendesk resource", {
    :collection    => lambda { client.topics },
    :create_params => lambda { { title: Zendesk2.uuid, body: Zendesk2.uuid, forum_id: forum.id } },
    :update_params => lambda { { title: Zendesk2.uuid, body: Zendesk2.uuid } },
  }
end
