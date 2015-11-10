class Zendesk2::Mock
  attr_reader :username, :url, :token, :jwt_token
  attr_accessor :last_request

  def self.data
    @data ||= Hash.new { |h,k| h[k] = {
      :categories             => {},
      :forums                 => {},
      :groups                 => {},
      :help_center_articles   => {},
      :help_center_categories => {},
      :help_center_sections   => {},
      :identities             => {},
      :memberships            => {},
      :organizations          => {},
      :ticket_audits          => {},
      :ticket_comments        => {},
      :ticket_fields          => {},
      :ticket_metrics         => {},
      :tickets                => {},
      :topic_comments         => {},
      :topics                 => {},
      :user_fields            => {},
      :users                  => {},
      :views                  => {},
    }
    }
  end

  def self.serial_id
    @current_id ||= 0
    @current_id += 1
    @current_id
  end

  def data
    self.class.data[@url]
  end

  def reset
    data.clear
  end

  def self.reset
    data.clear
  end

  def serial_id
    self.class.serial_id
  end

  def initialize(options={})
    @url                 = options[:url]
    @path                = URI.parse(url).path
    @username, @password = options[:username], options[:password]
    @token               = options[:token]
    @jwt_token           = options[:jwt_token]

    @current_user ||= self.data[:users].values.find { |u|
      @username == u["name"]
    } || self.create_user(
      "user" => {"email" => @username, "name" => @username}
    ).body["user"]

    @current_user_identity ||= self.data[:identities].values.first
  end

  # Lazily re-seeds data after reset
  # @return [Hash] current user response
  def current_user
    self.data[:users][@current_user["id"]]               ||= @current_user
    self.data[:identities][@current_user_identity["id"]] ||= @current_user_identity

    @current_user
  end
end
