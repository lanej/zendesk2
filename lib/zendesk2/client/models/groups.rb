class Zendesk2::Client::Groups < Zendesk2::Collection
  include Zendesk2::Searchable

  model Zendesk2::Client::Group

  self.collection_method = :get_groups
  self.collection_root   = "groups"
  self.model_method      = :get_group
  self.model_root        = "group"
  self.search_type       = "group"

  def assignable
    data = self.connection.get_assignable_groups.body
    collection = self.connection.groups.load(data["groups"])
    collection.merge_attributes(Cistern::Hash.slice(data, "next_page", "previous_page", "count"))
  end
end
