class Zendesk2::HelpCenter::Article < Zendesk2::Model
  extend Zendesk2::Attributes

  # @return [Integer] Automatically assigned when the article is created
  identity :id, type: :integer # ro:yes required:no

  # @return [Integer] The id of the user who wrote the article (set to the user who made the request on create by default)
  attribute :author_id, type: :integer # ro:no required:no
  # @return [String] The body of the article
  attribute :body, type: :string # ro:no required:no
  # @return [Boolean] True if comments are disabled; false otherwise
  attribute :comments_disabled, type: :boolean # ro:no required:no
  # @return [Time] The time at which the article was created
  attribute :created_at, type: :time # ro:yes required:no
  # @return [Boolean] True if the translation for the current locale is a draft; false otherwise. false by default
  attribute :draft, type: :boolean # ro:no required:no
  # @return [String] The url of the article in Help Center
  attribute :html_url, type: :string # ro:yes required:no
  # @return [String] An array of label names associated with this article. By default no label names are used (only available on certain plans)
  attribute :label_names, type: :string # ro:no required:no
  # @return [String] The locale that the article is being displayed in
  attribute :locale, type: :string # ro:no required:yes
  # @return [Boolean] Whether the article is out of date
  attribute :outdated, type: :boolean # ro:yes required:no
  # @return [Integer] The position of this article in the article list. '0' by default
  attribute :position, type: :integer # ro:no required:no
  # @return [Boolean] True if this article is promoted; false otherwise. false by default
  attribute :promoted, type: :boolean # ro:no required:no
  # @return [Integer] The id of the section to which this article belongs
  attribute :section_id, type: :integer # ro:no required:no
  # @return [String] The source (default) locale of the article
  attribute :source_locale, type: :string # ro:yes required:no
  # @return [String] The title of the article
  attribute :title, type: :string # ro:no required:yes
  # @return [Time] The time at which the article was last updated
  attribute :updated_at, type: :time # ro:yes required:no
  # @return [String] The API url of the article
  attribute :url, type: :string # ro:yes required:no
  # @return [Integer] The number of votes cast on this article
  attribute :vote_count, type: :integer # ro:yes required:no
  # @return [Integer] The total sum of votes on this article
  attribute :vote_sum, type: :integer # ro:yes required:no

  assoc_accessor :section, collection: :help_center_sections

  def save!
    response = if new_record?
                 requires :title, :locale, :section_id

                 service.create_help_center_article("article" => self.attributes)
               else
                 requires :identity

                 service.update_help_center_article("article" => self.attributes)
               end

    merge_attributes(response.body["article"])
  end

  def destroy!
    requires :identity

    service.destroy_help_center_article("article" => { "id" => self.identity })
  end
end
