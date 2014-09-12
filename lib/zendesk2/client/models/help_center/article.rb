class Zendesk2::Client::HelpCenter::Article < Zendesk2::Model
  extend Zendesk2::Attributes

  identity :id, type: :integer                # ro:yes required:no # Automatically assigned when the article is created

  attribute :author_id,         type: :integer   # ro:no required:no  # The id of the user who wrote the article (set to the user who made the request on create by default)
  attribute :body,              type: :string    # ro:no required:no  # The body of the article
  attribute :comments_disabled, type: :boolean   # ro:no required:no  # True if comments are disabled; false otherwise
  attribute :created_at,        type: :timestamp # ro:yes required:no # The time at which the article was created
  attribute :draft,             type: :boolean   # ro:no required:no  # True if the translation for the current locale is a draft; false otherwise. false by default
  attribute :html_url,          type: :string    # ro:yes required:no # The url of the article in Help Center
  attribute :label_names,       type: :string    # ro:no required:no  # An array of label names associated with this article. By default no label names are used (only available on certain plans)
  attribute :locale,            type: :string    # ro:no required:yes # The locale that the article is being displayed in
  attribute :outdated,          type: :boolean   # ro:yes required:no # Whether the article is out of date
  attribute :position,          type: :integer   # ro:no required:no  # The position of this article in the article list. '0' by default
  attribute :promoted,          type: :boolean   # ro:no required:no  # True if this article is promoted; false otherwise. false by default
  attribute :section_id,        type: :integer   # ro:no required:no  # The id of the section to which this article belongs
  attribute :source_locale,     type: :string    # ro:yes required:no # The source (default) locale of the article
  attribute :title,             type: :string    # ro:no required:yes # The title of the article
  attribute :updated_at,        type: :timestamp # ro:yes required:no # The time at which the article was last updated
  attribute :url,               type: :string    # ro:yes required:no # The API url of the article
  attribute :vote_count,        type: :integer   # ro:yes required:no # The number of votes cast on this article
  attribute :vote_sum,          type: :integer   # ro:yes required:no # The total sum of votes on this article
end
