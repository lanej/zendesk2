class Zendesk2::Organization < Zendesk2::Model

  # @return [integer] Automatically assigned when creating organization
  identity :id, type: :integer # ro[yes] required[no]

  # @return [Date] The time the organization was created
  attribute :created_at, type: :time # ro[yes] required[no]
  # @return [String] In this field you can store any details obout the organization. e.g. the address
  attribute :details, type: :string # ro[no] required[no]
  # @return [Array] An array of domain names associated with this organization
  attribute :domain_names, type: :array # ro[no] required[no]
  # @return [String] A unique external id, you can use this to associate organizations to an external record
  attribute :external_id, type: :string # ro[no] required[no]
  # @return [Integer] New tickets from users in this organization will automatically be put in this group
  attribute :group_id, type: :integer # ro[no] required[no]
  # @return [String] The name of the organization
  attribute :name, type: :string # ro[no] required[yes]
  # @return [String] In this field you can store any notes you have about the organization
  attribute :notes, type: :string # ro[no] required[no]
  # @return [Hash] Custom fields for this organization
  attribute :organization_fields, type: :hash # ro[no] required[no]
  # @return [Boolean] End users in this organization are able to see each other's comments on tickets
  attribute :shared_comments, type: :boolean # ro[no] required[no]
  # @return [Boolean] End users in this organization are able to see each other's tickets
  attribute :shared_tickets, type: :boolean # ro[no] required[no]
  # @return [Array] The tags of the organization
  attribute :tags, type: :array # ro[no] required[no]
  # @return [Date] The time of the last update of the organization
  attribute :updated_at, type: :time # ro[yes] required[no]
  # @return [String] The API url of this organization
  attribute :url, type: :string # ro[yes] required[no]

  def destroy!
    requires :identity

    service.destroy_organization("organization" => {"id" => self.identity})
  end

  def save!
    data = if new_record?
             requires :name

             service.create_organization("organization" => self.attributes)
           else
             requires :identity

             service.update_organization("organization" => self.attributes)
           end.body["organization"]

    merge_attributes(data)
  end

  # @return [Zendesk2::Users] users associated with this organization
  def users
    requires :identity

    service.users.load(
      service.get_organization_users("organization" => {"id" => self.identity}).body["users"]
    )
  end

  # @return [Zendesk2::Memberships] memberships associated with this organization
  def memberships
    requires :identity

    service.memberships(organization: self)
  end

  # @return [Zendesk2::Tickets] tickets associated with this organization
  def tickets
    requires :identity

    service.tickets.load(
      service.get_organization_tickets("organization_id" => self.identity).body["tickets"]
    )
  end
end
