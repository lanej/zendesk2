# frozen_string_literal: true
require 'spec_helper'

describe 'help_center/posts' do
  let(:client) { create_client }
  let!(:topic) { client.help_center_topics.create(name: mock_uuid) }

  include_examples 'zendesk#resource',
                   collection: -> { topic.posts },
                   create_params: -> { { title: mock_uuid, details: mock_uuid } },
                   update_params: -> { { title: mock_uuid, details: mock_uuid } },
                   search: false

  let(:author) { client.users.create!(email: mock_email, name: mock_uuid) }

  describe 'with an author' do
    include_examples 'zendesk#resource',
                     collection: -> { author.posts },
                     create_params: lambda {
                                      { title: mock_uuid, details: mock_uuid, topic_id: topic.id, author_id: author.id }
                                    },
                     update_params: -> { { title: mock_uuid, details: mock_uuid } },
                     search: false
  end

  describe 'with a post' do
    let!(:post) do
      client.help_center_posts.create(title: mock_uuid, details: mock_uuid, topic_id: topic.id, author_id: author.id)
    end

    it 'returns the author' do
      expect(post.author).to eq(author)
    end

    it 'returns the topic' do
      expect(post.topic).to eq(topic)
    end
  end
end
