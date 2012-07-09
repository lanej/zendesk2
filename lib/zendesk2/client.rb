class Zendesk2::Client < Cistern::Service

  model_path "zendesk2/client/models"
  request_path "zendesk2/client/requests"

  model :organization
  collection :organizations
  model :ticket
  collection :tickets
  model :user
  collection :users

  request :create_organization
  request :create_ticket
  request :create_user
  request :destroy_organization
  request :destroy_ticket
  request :destroy_user
  request :get_current_user
  request :get_organization
  request :get_organization_tickets
  request :get_organization_users
  request :get_ticket
  request :get_user
  request :get_organizations
  request :get_requested_tickets
  request :get_ccd_tickets
  request :get_tickets
  request :get_users
  request :search
  request :update_organization
  request :update_ticket
  request :update_user

  recognizes :url, :subdomain, :host, :port, :path, :scheme, :logger, :adapter, :username, :password, :token

  class Real

    attr_reader :username, :url

    def initialize(options={})
      url = options[:url] || begin
        host      = options[:host]
        subdomain = options[:subdomain] || Zendesk2.defaults[:subdomain]

        host ||= "#{subdomain}.zendesk.com"

        path   = options[:path] || "api/v2"
        scheme = options[:scheme] || "https"

        port   = options[:port] || (scheme == "https" ? 443 : 80)

        "#{scheme}://#{host}:#{port}/#{path}"
      end

      @url  = URI.parse(url).to_s

      logger             = options[:logger]
      adapter            = options[:adapter] || :net_http
      connection_options = options[:connection_options] || {ssl: {verify: false}}
      @username          = options[:username] || Zendesk2.defaults[:username]
      password           = options[:password] || Zendesk2.defaults[:password]
      @token             = options[:token]

      raise "Missing required options: [:username, :password]" unless @username && password

      @connection = Faraday.new({url: @url}.merge(connection_options)) do |builder|
        # response
        builder.use Faraday::Request::BasicAuthentication, @username, password
        builder.use Faraday::Response::RaiseError
        builder.use Faraday::Response::Logger, logger if logger
        builder.response :json

        # request
        builder.request :multipart
        builder.request :json

        builder.adapter adapter
      end
    end

    def request(options={})
      method  = options[:method] || :get
      url     = File.join(@url, options[:path])
      params  = options[:params] || {}
      body    = options[:body]
      headers = options[:headers] || {}

      @connection.send(method) do |req|
        req.url url
        req.headers.merge!(headers)
        req.params.merge!(params)
        req.body= body
      end
    rescue Faraday::Error::ClientError => e
      raise Zendesk2::Error.new(e)
    end
  end

  class Mock
    include Zendesk2::Errors

    attr_reader :username, :url, :token

    def self.data
      @data ||= {
        :users         => {},
        :organizations => {},
        :tickets       => {},
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
      url = options[:url] || begin
        host   = options[:host]
        host ||= "#{options[:subdomain] || "mock"}.zendesk.com"

        path   = options[:path] || "api/v2"
        scheme = options[:scheme] || "https"

        port   = options[:port] || (scheme == "https" ? 443 : 80)

        "#{scheme}://#{host}:#{port}/#{path}"
      end

      @url  = url
      @path = URI.parse(url).path
      @username, @password = options[:username], options[:password]
      @token = options[:token]

      @current_user_id = self.class.new_id

      self.data[:users][@current_user_id]= {
        "id"    => @current_user_id,
        "email" => @username,
        "name"  => "Mock Agent",
        "url"   => url_for("/users/#{@current_user_id}.json"),
      }
    end

    def url_for(path)
      File.join(@url, path)
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

    def response(options={})
      method = options[:method] || :get
      status = options[:status] || 200
      path   = options[:path]
      body   = options[:body]

      url = options[:url] || url_for(path)

      env = {
        :method           => method,
        :status           => status,
        :url              => url,
        :body             => body,
        :response_headers => {
          "Content-Type"  => "application/json; charset=utf-8"
        },
      }
      Faraday::Response::RaiseError.new.on_complete(env) || Faraday::Response.new(env)
    rescue Faraday::Error::ClientError => e
      raise Zendesk2::Error.new(e)
    end
  end
end
