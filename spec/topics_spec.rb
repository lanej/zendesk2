require 'spec_helper'

describe "topics" do
  let(:client) { create_client }
  let(:forum) { client.forums.create(name: Zendesk2.uuid) }
  it_should_behave_like "a resource",
    :topics,
    lambda { {title: Zendesk2.uuid, body: Zendesk2.uuid, forum_id: forum.id} },
    lambda { {title: Zendesk2.uuid, body: Zendesk2.uuid} }
end
