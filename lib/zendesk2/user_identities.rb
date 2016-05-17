class Zendesk2::UserIdentities < Zendesk2::Collection
  model Zendesk2::UserIdentity

  attribute :user_id, type: :integer
  attribute :count, type: :integer

  self.collection_method = :get_user_identities
  self.collection_root   = "identities"
  self.model_method      = :get_user_identity
  self.model_root        = "identity"
  self.namespace         = "user_identity"

  scopes << :user_id
end
