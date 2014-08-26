class Zendesk2::Client < Cistern::Service
  USER_AGENT = "Ruby/#{RUBY_VERSION} (#{RUBY_PLATFORM}; #{RUBY_ENGINE}) Zendesk2/#{Zendesk2::VERSION} Faraday/#{Faraday::VERSION}".freeze

  model_path "zendesk2/client/models"
  request_path "zendesk2/client/requests"

  require 'zendesk2/client/models/audit_event' # so special

  collection :categories
  collection :forums
  collection :groups
  collection :memberships
  collection :organizations
  collection :ticket_audits
  collection :ticket_fields
  collection :ticket_metrics
  collection :tickets
  collection :ticket_comments
  collection :topic_comments
  collection :topics
  collection :user_fields
  collection :user_identities
  collection :users
  model :category
  model :forum
  model :group
  model :membership
  model :organization
  model :ticket
  model :ticket_audit
  model :ticket_metric
  model :ticket_change
  model :ticket_comment
  model :ticket_comment_privacy_change
  model :ticket_create
  model :ticket_field
  model :ticket_notification
  model :ticket_voice_comment
  model :topic
  model :topic_comment
  model :user
  model :user_field
  model :user_identity

  request :create_category
  request :create_forum
  request :create_group
  request :create_membership
  request :create_organization
  request :create_ticket
  request :create_ticket_field
  request :create_topic
  request :create_topic_comment
  request :create_user
  request :create_user_field
  request :create_user_identity
  request :destroy_category
  request :destroy_forum
  request :destroy_group
  request :destroy_membership
  request :destroy_organization
  request :destroy_ticket
  request :destroy_ticket_field
  request :destroy_topic
  request :destroy_topic_comment
  request :destroy_user
  request :destroy_user_field
  request :destroy_user_identity
  request :get_assignable_groups
  request :get_audits
  request :get_categories
  request :get_category
  request :get_ccd_tickets
  request :get_current_user
  request :get_forum
  request :get_forums
  request :get_group
  request :get_groups
  request :get_membership
  request :get_organization
  request :get_organization_by_external_id
  request :get_organization_memberships
  request :get_organization_tickets
  request :get_organization_users
  request :get_organizations
  request :get_requested_tickets
  request :get_ticket
  request :get_ticket_audit
  request :get_ticket_audits
  request :get_ticket_comments
  request :get_ticket_field
  request :get_ticket_fields
  request :get_ticket_metric
  request :get_ticket_metrics
  request :get_tickets
  request :get_topic
  request :get_topic_comment
  request :get_topic_comments
  request :get_topics
  request :get_user
  request :get_user_field
  request :get_user_fields
  request :get_user_identities
  request :get_user_identity
  request :get_user_memberships
  request :get_users
  request :mark_membership_default
  request :mark_user_identity_primary
  request :search
  request :search_user
  request :update_category
  request :update_forum
  request :update_group
  request :update_organization
  request :update_request
  request :update_ticket
  request :update_ticket_field
  request :update_topic
  request :update_topic_comment
  request :update_user
  request :update_user_field
  request :update_user_identity

  recognizes :url, :subdomain, :host, :port, :path, :scheme, :logger, :adapter, :username, :password, :token, :jwt_token

  module Shared
    def require_parameters(params, *requirements)
      if (missing = requirements - params.keys).any?
        raise ArgumentError, "missing parameters: #{missing.join(", ")}"
      end
    end

    private

    def zendesk_url(options)
      options[:url] || Zendesk2.defaults[:url] || form_zendesk_url(options)
    end

    def form_zendesk_url(options)
      host      = options[:host]
      subdomain = options[:subdomain] || Zendesk2.defaults[:subdomain]

      host ||= "#{subdomain}.zendesk.com"
      scheme = options[:scheme] || "https"
      port   = options[:port] || (scheme == "https" ? 443 : 80)

      "#{scheme}://#{host}:#{port}"
    end
  end

  class Real
    include Shared

    attr_accessor :username, :url, :token, :logger, :jwt_token

    def initialize(options={})
      options[:subdomain] ||= "mock"
      url = zendesk_url(options)
      @url  = ::URI.parse(url).to_s

      @logger            = options[:logger] || Logger.new(nil)
      adapter            = options[:adapter] || :net_http
      connection_options = options[:connection_options] || {ssl: {verify: false}}
      @username          = options[:username] || Zendesk2.defaults[:username]
      @token             = options[:token] || Zendesk2.defaults[:token]
      password           = options[:password] || Zendesk2.defaults[:password]
      @auth_token        = password || @token
      @username         += "/token" if @auth_token == @token
      @jwt_token         = options[:jwt_token]

      raise "Missing required options: :username" unless @username
      raise "Missing required options: :password or :token" unless password || @token

      @connection = Faraday.new({url: @url}.merge(connection_options)) do |builder|
        # response
        builder.use Faraday::Request::BasicAuthentication, @username, @auth_token
        builder.use Faraday::Response::RaiseError
        builder.response :json

        # request
        builder.request :multipart
        builder.request :json

        builder.use Zendesk2::Logger, @logger
        builder.adapter adapter
      end
    end

    def request(options={})
      method  = options[:method] || :get
      url     = options[:url] || File.join(@url, "/api/v2", options[:path])
      params  = options[:params] || {}
      body    = options[:body]
      headers = {"User-Agent" => USER_AGENT}.merge(options[:headers] || {})

      @connection.send(method) do |req|
        req.url url
        req.headers.merge!(headers)
        req.params.merge!(params)
        req.body = body
      end
    rescue Faraday::Error::ClientError => e
      raise Zendesk2::Error.new(e)
    end
  end

  class Mock
    include Shared

    attr_reader :username, :url, :token, :jwt_token

    def self.data
      @data ||= {
        :categories      => {},
        :forums          => {},
        :groups          => {},
        :identities      => {},
        :memberships     => {},
        :organizations   => {},
        :ticket_audits   => {},
        :ticket_comments => {},
        :ticket_fields   => {},
        :ticket_metrics  => {},
        :tickets         => {},
        :topic_comments  => {},
        :topics          => {},
        :user_fields     => {},
        :users           => {},
      }
    end

    def self.new_id
      @current_id ||= 0
      @current_id += 1
    end

    def data
      self.class.data
    end

    def self.reset!
      @data = nil
    end

    def initialize(options={})
      url = zendesk_url(options)

      @url  = url
      @path = ::URI.parse(url).path
      @username, @password = options[:username], options[:password]
      @token = options[:token]
      @jwt_token = options[:jwt_token]

      @current_user ||= self.create_user("email" => @username, "name" => "Mock Agent").body["user"]
      @current_user_identity ||= self.data[:identities].values.first
    end

    # Lazily re-seeds data after reset
    # @return [Hash] current user response
    def current_user
      self.data[:users][@current_user["id"]] ||= @current_user
      self.data[:identities][@current_user_identity["id"]] ||= @current_user_identity

      @current_user
    end

    def url_for(path)
      File.join(@url, "/api/v2", path.to_s)
    end

    def resources(collection, path, collection_root, options={})
      filter    = options[:filter]
      resources = self.data[collection].values
      resources = filter.call(resources) if filter
      count     = resources.size

      response(
        :body => {
          collection_root => resources,
          "count"         => count,
        },
        :path => path
      )
    end

    def page(params, collection, path, collection_root, options={})
      page_params = Zendesk2.paging_parameters(params)
      page_size   = (page_params["per_page"] || 50).to_i
      page_index  = (page_params["page"] || 1).to_i
      offset      = (page_index - 1) * page_size
      filter      = options[:filter]
      resources   = self.data[collection].values
      resources   = filter.call(resources) if filter
      count       = resources.size
      total_pages = (count / page_size) + 1

      next_page = if page_index < total_pages
                    url_for("#{path}?page=#{page_index + 1}&per_page=#{page_size}")
                  end
      previous_page = if page_index > 1
                        url_for("#{path}?page=#{page_index - 1}&per_page=#{page_size}")
                      end

      resource_page = resources.slice(offset, page_size)

      body = {
        collection_root => resource_page,
        "count"         => count,
        "next_page"     => next_page,
        "previous_page" => previous_page,
      }

      response(
        :body => body,
        :path => path
      )
    end

    def pluralize(word)
      pluralized = word.dup
      [[/y$/, 'ies'], [/$/, 's']].find{|regex, replace| pluralized.gsub!(regex, replace) if pluralized.match(regex)}
      pluralized
    end

    def self.error_map
      @@error_map ||= {
        :invalid => [422, {
          "error"       => "RecordInvalid",
          "description" => "Record validation errors",
        }],
        :not_found => [404, {
          "error"       => "RecordNotFound",
          "description" => "Not found",
        }],
      }
    end

    def find!(collection, identity, options={})
      if resource = self.data[collection][identity]
        resource
      else
        error!(options[:error] || :not_found)
      end
    end

    def error!(type, options={})
      status, body = self.class.error_map[type]
      body.merge!("details" => options[:details]) if options[:details]

      response(
        :status => status,
        :body   => body,
      )
    end

    def response(options={})
      method = options[:method] || :get
      status = options[:status] || 200
      path   = options[:path]
      body   = options[:body]

      url = options[:url] || url_for(path)

      env = Faraday::Env.new(method, body, url, nil, {}, nil, nil, {}, nil, {"Content-Type"  => "application/json; charset=utf-8"}, status)

      Faraday::Response::RaiseError.new.on_complete(env) || Faraday::Response.new(env)
    rescue Faraday::Error::ClientError => e
      raise Zendesk2::Error.new(e)
    end
  end
end
