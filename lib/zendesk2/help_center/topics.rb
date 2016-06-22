# frozen_string_literal: true
class Zendesk2::HelpCenter::Topics
  include Zendesk2::Collection

  model Zendesk2::HelpCenter::Topic

  attribute :count

  self.collection_method = :get_help_center_topics
  self.collection_root   = 'topics'
  self.model_method      = :get_help_center_topic
  self.model_root        = 'topic'
end
