class Zendesk2::Client::UserIdentities < Zendesk2::Client::Collection
  model Zendesk2::Client::UserIdentity

  attribute :user_id, type: :integer
  attribute :count, type: :integer

  self.collection_method = :get_user_identities
  self.collection_root   = "identities"
  self.model_method      = :get_user_identity
  self.model_root        = "identity"
  self.namespace         = "user_identity"

  scopes << :user_id
end
