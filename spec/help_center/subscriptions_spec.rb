# frozen_string_literal: true
require 'spec_helper'

describe 'help_center/subscriptions' do
  let(:client) { create_client }
  let(:category) { client.help_center_categories.create!(name: mock_uuid, locale: 'en-us') }
  let(:section) do
    client.help_center_sections.create!(name: mock_uuid,
                                        locale: 'en-us',
                                        category: category)
  end

  describe 'with an article' do
    let!(:article) do
      client.help_center_articles.create!(title: mock_uuid,
                                          locale: 'en-us',
                                          section: section)
    end

    include_examples 'zendesk#resource',
                     collection: -> { article.subscriptions },
                     create_params: -> { { locale: 'en-us' } },
                     destroy: false,
                     update: false,
                     paged: false,
                     search: false
  end

  describe 'with an section' do
    before { section }

    include_examples 'zendesk#resource',
                     collection: -> { section.subscriptions },
                     create_params: -> { { locale: 'en-us' } },
                     destroy: false,
                     update: false,
                     paged: false,
                     search: false
  end

  describe 'with a topic' do
    let!(:topic) { client.help_center_topics.create(name: mock_uuid) }

    include_examples 'zendesk#resource',
                     collection: -> { topic.subscriptions },
                     create_params: -> { { include_comments: true } },
                     destroy: false,
                     update: false,
                     paged: false,
                     search: false
  end

  describe 'with a post' do
    let!(:author) { client.users.create!(email: mock_email, name: mock_uuid) }
    let!(:topic) { client.help_center_topics.create(name: mock_uuid) }
    let!(:post) do
      client.help_center_posts.create(title: mock_uuid, details: mock_uuid, topic_id: topic.id, author_id: author.id)
    end

    include_examples 'zendesk#resource',
                     collection: -> { post.subscriptions },
                     create_params: -> { { user_id: author.id } },
                     destroy: false,
                     update: false,
                     paged: false,
                     search: false
  end
end
