require 'spec_helper'

describe "topic_comments" do
  let!(:client) { create_client }
  let!(:user)   { client.users.create!(email: mock_email, name: mock_uuid, verified: true) }
  let!(:forum)  { client.forums.create!(name: mock_uuid) }
  let!(:topic)  { client.topics.create!(title: mock_uuid, body: mock_uuid, forum: forum) }

  include_examples "zendesk resource",
    {
      :create_params => lambda { { body: mock_uuid, topic_id: topic.identity, user_id: user.identity } },
      :update        => false,
      :fetch_params  => lambda { |tc| {"topic_id" => tc.topic_id, "id" => tc.identity} },
      :collection    => lambda { client.topic_comments(topic_id: topic.identity) },
    }
end
