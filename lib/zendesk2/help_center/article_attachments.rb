# frozen_string_literal: true
class Zendesk2::HelpCenter::ArticleAttachments
  include Zendesk2::Collection

  include Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::HelpCenter::ArticleAttachment

  self.collection_method = :get_help_center_article_attachments
  self.collection_root   = 'article_attachments'
  self.model_method      = :get_help_center_article_attachment
  self.model_root        = 'article_attachment'
end
