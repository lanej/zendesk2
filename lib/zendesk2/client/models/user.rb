class Zendesk2::Client::User < Zendesk2::Model
  extend Zendesk2::Attributes

  PARAMS = %w[name email organization_id external_id alias verified locate_id time_zone phone signature details notes role custom_role_id moderator ticket_restriction only_private_comments]

  # @return [Integer] Automatically assigned when creating users
  identity :id, type: :integer

  # @return [Boolean] Users that have been deleted will have the value false here
  attribute :active, type: :boolean
  # @return [String] Agents can have an alias that is displayed to end-users
  attribute :alias, type: :string
  # @return [Time] The time the user was created
  attribute :created_at, type: :time
  # @return [Integer] A custom role on the user if the user is an agent on the entreprise plan
  attribute :custom_role_id, type: :integer
  # @return [String] In this field you can store any details obout the user. e.g. the address
  attribute :details, type: :string
  # @return [String] The primary email address of this user
  attribute :email, type: :string
  # @return [String] A unique id you can set on a user
  attribute :external_id, type: :string
  # @return [Array] Array of user identities (e.g. email and Twitter) associated with this user. See User Identities
  attribute :identities, type: :array
  # @return [Time] A time-stamp of the last time this user logged in to Zendesk
  attribute :last_login_at, type: :time
  # @return [Integer] The language identifier for this user
  attribute :locale_id, type: :integer
  # @return [Boolean] Designates whether this user has forum moderation capabilities
  attribute :moderator, type: :boolean
  # @return [String] The name of the user
  attribute :name, type: :string
  # @return [String] In this field you can store any notes you have about the user
  attribute :notes, type: :string
  # @return [Boolean] true if this user only can create private comments
  attribute :only_private_comments, type: :boolean
  # @return [Integer] The id of the organization this user is associated with
  attribute :organization_id, type: :integer
  # @return [String] The primary phone number of this user
  attribute :phone, type: :string
  # @return [Attachment] The user's profile picture represented as an Attachment object
  attribute :photo, type: :Attachment
  # @return [String] The role of the user. Possible values: "end-user", "agent", "admin"
  attribute :role, type: :string
  # @return [Boolean] If this user is shared from a different Zendesk, ticket sharing accounts only
  attribute :shared, type: :boolean
  # @return [String] The signature of this user. Only agents and admins can have signatures
  attribute :signature, type: :string
  # @return [Boolean] Tickets from suspended users are also suspended, and these users cannot log in to the end-user portal
  attribute :suspended, type: :boolean
  # @return [Array] The tags of the user. Only present if your account has user tagging enabled
  attribute :tags, type: :array
  # @return [String] Specified which tickets this user has access to. Possible values are: "organization", "groups", "assigned", "requested", null
  attribute :ticket_restriction, type: :string
  # @return [String] The time-zone of this user
  attribute :time_zone, type: :string
  # @return [Time] The time of the last update of the user
  attribute :updated_at, type: :time
  # @return [String] The API url of this user
  attribute :url, type: :string
  # @return [Boolean] Zendesk has verified that this user is who he says he is
  attribute :verified, type: :boolean

  attr_accessor :errors
  assoc_accessor :organization

  def save!
    data = if new_record?
             requires :name, :email

             connection.create_user(params).body["user"]
           else
             requires :identity

             connection.update_user(params.merge("id" => self.identity)).body["user"]
           end

    merge_attributes(data)
  end

  def destroy!
    requires :identity
    raise "don't nuke yourself" if self.email == connection.username

    data = connection.destroy_user("id" => self.identity).body["user"]
    merge_attributes(data)
  end

  def destroyed?
    !reload || !self.active
  end

  # @param [Time] timestamp time sent with intial handshake
  # @option options [String] :return_to (nil) url to return to after handshake
  # @return [String] remote authentication login url
  # Using this method requires you to implement the additional (user-defined) /handshake endpoint
  # @see http://www.zendesk.com/support/api/remote-authentication
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
      query_values['return_to'] = return_to
    end
    uri.query_values = query_values

    uri.to_s
  end

  # @option options [String] :return_to (nil) url to return to after initial auth
  # @return [String] url to redirect your user's browser to for login
  # @see https://support.zendesk.com/entries/23675367-Setting-up-single-sign-on-with-JWT-JSON-Web-Token-
  # Cargo-culted from: https://github.com/zendesk/zendesk_jwt_sso_examples/blob/master/ruby_on_rails_jwt.rb
  def jwt_login_url(options = {})
    requires :name, :email

    return_to = options[:return_to]
    jwt_token = self.connection.jwt_token || options[:jwt_token]

    uri       = Addressable::URI.parse(self.connection.url)
    uri.path  = "/access/jwt"

    iat = Time.now.to_i
    jti = "#{iat}/#{rand(36**64).to_s(36)}"
    payload = JWT.encode({
      :iat    => iat, # Seconds since epoch, determine when this token is stale
      :jti    => jti, # Unique token id, helps prevent replay attacks
      :name   => self.name,
      :email  => self.email,
    }, jwt_token)

    query_values = {
      'jwt' => payload
    }
    unless Zendesk2.blank?(return_to)
      query_values['return_to'] = return_to
    end
    uri.query_values = query_values

    uri.to_s
  end

  # @return [Zendesk2::Client::Tickets] tickets this user requested
  def tickets
    requires :identity

    data = connection.get_requested_tickets("id" => self.identity).body["tickets"]

    connection.tickets.load(data)
  end
  alias requested_tickets tickets

  # @return [Zendesk2::Client::Tickets] tickets this user is CC'eD
  def ccd_tickets
    requires :identity

    data = connection.get_ccd_tickets("id" => self.identity).body["tickets"]

    connection.tickets.load(data)
  end

  # @return [Zendesk2::Client::UserIdentities] the identities of this user
  def identities
    self.connection.user_identities("user_id" => self.identity)
  end

  private

  def params
    writable_attributes = Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), *PARAMS)
    writable_attributes.delete("organization_id") if writable_attributes["organization_id"] == 0
    writable_attributes.delete("custom_role_id") if writable_attributes["custom_role_id"] == 0
    writable_attributes
  end
end
