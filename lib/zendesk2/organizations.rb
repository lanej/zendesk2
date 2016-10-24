# frozen_string_literal: true
class Zendesk2::Organizations
  include Zendesk2::Collection

  include Zendesk2::PagedCollection
  include Zendesk2::Searchable
  extend Zendesk2::Attributes

  model Zendesk2::Organization

  attribute :user_id, type: :integer

  assoc_accessor :user

  def find_by_external_id(external_id)
    body = cistern.get_organization_by_external_id('external_id' => external_id).body
    data = body.delete('organizations')

    return unless data

    collection = clone.load(data)
    collection.merge_attributes(Cistern::Hash.slice(body, 'count', 'next_page', 'previous_page'))
    collection
  end

  self.collection_method = :get_organizations
  self.collection_root   = 'organizations'
  self.model_method      = :get_organization
  self.model_root        = 'organization'
  self.search_type       = 'organization'
  self.search_request    = :search_organization

  def collection_page(params = {})
    collection_method = if user_id
                          :get_user_organizations
                        else
                          :get_organizations
                        end

    body = cistern.send(collection_method, Cistern::Hash.stringify_keys(attributes.merge(params))).body

    load(body[collection_root])
    merge_attributes(Cistern::Hash.slice(body, 'count', 'next_page', 'previous_page'))
    self
  end
end
