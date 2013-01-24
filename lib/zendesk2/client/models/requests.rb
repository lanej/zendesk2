class Zendesk2::Client::Requests < Zendesk2::Collection
  include Zendesk2::Searchable

  model Zendesk2::Client::Request

  self.collection_method = :get_requests
  self.collection_root   = "requests"
  self.model_method      = :get_request
  self.model_root        = "request"
  self.search_type       = "request"
end
