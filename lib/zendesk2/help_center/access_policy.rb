class Zendesk2::HelpCenter::AccessPolicy < Zendesk2::Model
  extend Zendesk2::Attributes

  # @return [String] Category of users who can view the section
  attribute :viewable_by, type: :string # ro:no required:no
  # @return [String] Category of users who can manage the section
  attribute :managable_by, type: :string # ro:no required:no
  # @return [Array] The ids of all groups who can access the section
  attribute :restricted_to_group_ids, type: :array # ro:no required:no
  # @return [Array] The ids of all organizations who can access the section
  attribute :restricted_to_organization_ids, type: :array # ro:no required:no
  # @return [Array] The tags a user must have to have access
  attribute :required_tags, type: :array # ro:no required:no

  attr_accessor :section_id
  assoc_accessor :section, collection: :help_center_sections

  def save!
    requires :section_id

    response = service.update_help_center_access_policy("access_policy" => self.attributes, "section_id" => self.section_id)
    merge_attributes(response.body["access_policy"])
  end
end
