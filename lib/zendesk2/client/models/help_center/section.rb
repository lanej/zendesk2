class Zendesk2::Client::HelpCenter::Section < Zendesk2::Model
  extend Zendesk2::Attributes

  # @return [Integer] Automatically assigned when creating subscriptions
  identity :id, type: :integer

  # @return [Integer] The id of the category to which this section belongs
  attribute :category_id, type: :integer # ro:no required:no
  # @return [Time] The time at which the section was created
  attribute :created_at, type: :datetime # ro:yes required:no
  # @return [String] The description of the section
  attribute :description, type: :string # ro:no required:no
  # @return [String] The url of this section in HC
  attribute :html_url, type: :string # ro:yes required:no
  # @return [String] The locale in which the section is displayed
  attribute :locale, type: :string # ro:no required:yes
  # @return [String] The name of the section
  attribute :name, type: :string # ro:no required:yes
  # @return [Boolean] Whether the section is out of date
  attribute :outdated, type: :boolean # ro:yes required:no
  # @return [Integer] The position of this section in the section list. By default the section is added to the end of the list
  attribute :position, type: :integer # ro:no required:no
  # @return [String] The sorting of articles within this section. By default it's set to manual. See sorting below.
  attribute :sorting, type: :string # ro:no required:no
  # @return [String] The source (default) locale of the section
  attribute :source_locale, type: :string # ro:yes required:no
  # @return [Array] The ids of all translations of this section
  attribute :translation_ids, type: :array # ro:yes required:no
  # @return [Time] The time at which the section was last updated
  attribute :updated_at, type: :datetime # ro:yes required:no
  # @return [string] The API url of this section
  attribute :url, type: :string # ro:yes required:no

  # @return [Zendesk2::Client::HelpCenter::Category] category containing this section
  assoc_accessor :category, collection: :help_center_categories

  def save!
    requires :name, :locale, :category_id

    data = if new_record?
             connection.create_help_center_section(params).body["section"]
           else
             connection.update_help_center_section(dirty_attributes.merge("id" => self.identity)).body["section"]
           end

    merge_attributes(data)
  end

  private

  def params
    Cistern::Hash.slice(self.attributes, :category_id, :description, :locale, :name, :position, :sorting)
  end
end
