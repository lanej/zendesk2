class Zendesk2::Client::HelpCenter::Sections < Zendesk2::Client::Collection
  include Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::Client::HelpCenter::Section

  self.collection_method = :get_help_center_sections
  self.collection_root   = "sections"
  self.model_method      = :get_help_center_section
  self.model_root        = "section"
end
