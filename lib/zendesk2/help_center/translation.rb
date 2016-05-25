class Zendesk2::HelpCenter::Translation
  include Zendesk2::Model
  include Zendesk2::HelpCenter::TranslationSource::Model

  extend Zendesk2::Attributes

  # @return [Integer] Automatically assigned when the translation is created
  identity :id, type: :integer # ro:yes required:no

  # @return [String] The API url of the translation
  attribute :url, type: :string # ro:yes required:no
  # @return [String] The url of the translation in Help Center
  attribute :html_url, type: :string # ro:yes required:no
  # @return [Integer]	The id of the item that has this translation
  attribute :source_id, type: :integer # ro:yes required:no
  # @return [String] The type of the item that has this translation. Can be Article, Section, or Category
  attribute :source_type, type: :string # ro:yes required:no
  # @return [String] The locale of the translation
  attribute :locale, type: :string # ro:no required:yes
  # @return [String] The title of the translation
  attribute :title, type: :string # ro:no required:yes
  # @return [String] The body of the translation. Empty by default
  attribute :body, type: :string # ro:no required:no
  # @return [Boolean] True if the translation is outdated; false otherwise. False by default
  attribute :outdated, type: :boolean # ro:no required:no
  # @return [Boolean] True if the translation is a draft; false otherwise. False by default
  attribute :draft, type: :boolean # ro:no required:no

  def destroy!
    requires :locale, :source_id, :source_type

    cistern.destroy_help_center_translation("translation" => Cistern::Hash.slice(self.attributes, :source_id, :source_type, :locale))
  end

  def save!
    response = if new_record?
                 requires :locale, :source_id, :source_type

                 cistern.create_help_center_translation("translation" => self.attributes)
               else
                 requires :identity

                 cistern.update_help_center_translation("translation" => self.attributes)
               end

    merge_attributes(response.body["translation"])
  end
end
