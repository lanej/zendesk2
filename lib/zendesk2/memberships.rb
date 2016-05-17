class Zendesk2::Memberships < Zendesk2::Collection
  include Zendesk2::PagedCollection
  extend Zendesk2::Attributes

  model Zendesk2::Membership

  attribute :user_id, type: :integer
  attribute :organization_id, type: :integer

  assoc_accessor :organization
  assoc_accessor :user

  self.collection_root = "organization_memberships"
  self.model_method    = :get_membership
  self.model_root      = "organization_membership"

  def all(params={})
    requires_one :user_id, :organization_id

    body = if self.user_id && self.organization_id
             {
               "organization_memberships" => [
                 service.get_membership("user_id" => self.user_id, "organization_id" => self.organization_id).body["organization_membership"]
               ]
             }
           elsif self.user_id
             service.get_user_memberships({"membership" => { "user_id" => self.user_id }}.merge(params)).body
           else
             service.get_organization_memberships({"membership" => { "organization_id" => self.organization_id }}.merge(params)).body
           end

    self.load(body[collection_root])
    self.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
    self
  end

  scopes << :user_id
  scopes << :organization_id
end
