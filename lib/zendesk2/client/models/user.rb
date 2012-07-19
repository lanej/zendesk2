class Zendesk2::Client::User < Cistern::Model
  extend Zendesk2::Attributes

  PARAMS = %w[name email organization_id external_id alias verified locate_id time_zone phone signature details notes role custom_role_id moderator ticket_restriction only_private_comments]

  identity :id,                     type: :id
  attribute :url
  attribute :external_id
  attribute :name
  attribute :alias
  attribute :created_at,            type: :time
  attribute :updated_at,            type: :time
  attribute :active,                type: :boolean
  attribute :verified,              type: :boolean
  attribute :shared,                type: :boolean
  attribute :locale_id,             type: :integer
  attribute :locale
  attribute :time_zone
  attribute :last_login_at,         type: :time
  attribute :email
  attribute :phone
  attribute :signature
  attribute :details,               type: :string
  attribute :notes
  attribute :organization_id,       type: :integer
  attribute :role
  attribute :custom_role_id,        type: :integer
  attribute :moderator,             type: :boolean
  attribute :ticket_restriction
  attribute :only_private_comments, type: :boolean
  attribute :tags,                  type: :array
  attribute :suspended,             type: :boolean
  attribute :photo
  attribute :authenticity_token

  assoc_accessor :organization

  def save
    if new_record?
      requires :name, :email
      data = connection.create_user(params).body["user"]
      merge_attributes(data)
    else
      requires :identity
      data = connection.update_user(params.merge("id" => self.identity)).body["user"]
      merge_attributes(data)
    end
  end

  def destroy!
    requires :identity
    raise "don't nuke yourself" if self.email == connection.username

    data = connection.destroy_user("id" => self.identity).body["user"]
    merge_attributes(data)
  end

  def destroy
    destroy!
  rescue Zendesk2::Error => e
    false
  end

  def destroyed?
    !reload || !self.active
  end

  def login_url(timestamp, options={})
    requires :name, :email

    return_to = options[:return_to]
    token     = self.connection.token || options[:token]

    uri      = Addressable::URI.parse(self.connection.url)
    uri.path = "/access/remote"

    raise "timestamp cannot be nil" unless timestamp

    hash_str = "#{self.name}#{self.email}#{token}#{timestamp}"
    query_values = {
      'name'      => name,
      'email'     => email,
      'timestamp' => timestamp,
      'hash'      => Digest::MD5.hexdigest(hash_str)
    }
    unless Zendesk2.blank?(return_to)
      query_values['return_to']= return_to
    end
    uri.query_values = query_values

    uri.to_s
  end

  def requested_tickets
    requires :identity

    data = connection.get_requested_tickets("id" => self.identity).body["tickets"]

    connection.tickets.load(data)
  end

  def ccd_tickets
    requires :identity

    data = connection.get_ccd_tickets("id" => self.identity).body["tickets"]

    connection.tickets.load(data)
  end

  private

  def params
    writable_attributes = Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), *PARAMS)
    writable_attributes.delete("organization_id") if writable_attributes["organization_id"] == 0
    writable_attributes.delete("custom_role_id") if writable_attributes["custom_role_id"] == 0
    writable_attributes
  end
end
