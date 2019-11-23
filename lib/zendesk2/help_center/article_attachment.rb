# frozen_string_literal: true
class Zendesk2::HelpCenter::ArticleAttachment
  include Zendesk2::Model

  extend Zendesk2::Attributes

  # @return [Integer] Automatically assigned when the article attachment is created
  identity :id, type: :integer # ro:yes required:no
  # @return [String] The API url of this article attachment
  attribute :url, type: :string # ro:no required:no
  # @return [Integer] Id of the associated article, if present
  attribute :article_id, type: :integer # ro:no required:no
  # @return [String] The name of the file
  attribute :file_name, type: :string # ro:no required:yes
  # @return [String] A full URL where the attachment file can be downloaded
  attribute :content_url, type: :string # ro:yes required:no
  # @return [String] The content type of the file. Example: image/png
  attribute :content_type, type: :string # ro:yes required:yes
  # @return [Integer] The size of the attachment file in bytes
  attribute :size, type: :integer # ro:no required:no
  # @return [Boolean] If true, the attached file is shown in the dedicated admin UI for inline attachments and its url can be referenced in the HTML body of the article. If false, the attachment is listed in the list of attachments. Default is false
  attribute :inline, type: :boolean # ro:no required:no

  # @return [Time] The time at which the article was created
  attribute :created_at, type: :time # ro:yes required:no
  # @return [Time] The time at which the article was last updated
  attribute :updated_at, type: :time # ro:yes required:no
  # @return [Integer] The number of votes cast on this article

  assoc_accessor :article, collection: :help_center_articles
end
