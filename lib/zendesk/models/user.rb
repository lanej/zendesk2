class Zendesk::Client::User < Cistern::Model
  identity :id
  attribute :url
  attribute :name
  attribute :email
end
