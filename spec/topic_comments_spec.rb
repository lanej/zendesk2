require 'spec_helper'

describe "topic_comments" do
  let!(:client) { create_client }
  let!(:user)   { client.users.create!(email: "zendesk2+#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, verified: true) }
  let!(:forum)  { client.forums.create!(name: Zendesk2.uuid) }
  let!(:topic)  { client.topics.create!(title: Zendesk2.uuid, body: Zendesk2.uuid, forum: forum) }
  it_should_behave_like "a resource", :topic_comments,
    lambda { {body: Zendesk2.uuid, topic_id: topic.identity, user_id: user.identity} },
    lambda { {body: Zendesk2.uuid} },
    {
      :fetch_params => lambda {|tc| {"topic_id" => tc.topic_id, "id" => tc.identity}},
      :collection   => lambda { client.topic_comments(topic_id: topic.identity) },
    }
end
