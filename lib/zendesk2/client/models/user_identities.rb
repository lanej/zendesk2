class Zendesk2::Client::UserIdentities < Zendesk2::Collection
  include Zendesk2::Searchable

  model Zendesk2::Client::UserIdentity

  attribute :user_id, type: :integer

  self.collection_method = :get_user_identities
  self.collection_root   = "identities"
  self.model_method      = :get_user_identity
  self.model_root        = "identity"
  self.search_type       = "identity"

  scopes << :user_id
end
