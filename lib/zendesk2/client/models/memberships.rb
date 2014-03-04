class Zendesk2::Client::Memberships < Zendesk2::Collection

  model Zendesk2::Client::Membership

  attribute :user_id, type: :integer
  attribute :organization_id, type: :integer

  self.collection_root   = "memberships"
  self.model_method      = :get_membership
  self.model_root        = "organization_membership"

  def all(params={})
    requires_one :user_id, :organization_id

    body = if self.user_id && self.organization_id
             { "organization_memberships" => [ connection.get_membership("user_id" => self.user_id, "organization_id" => self.organization_id).body["organization_membership"] ]
             }
           elsif self.user_id
             connection.get_user_memberships("user_id" => self.user_id).body
           else
             connection.get_organization_memberships("organization_id" => self.organization_id).body
           end

    self.load(body[collection_root])
    self.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
    self
  end

  scopes << :user_id
  scopes << :organization_id
end
