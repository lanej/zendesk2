class Zendesk2::Client < Cistern::Service

  model_path "zendesk2/models"
  request_path "zendesk2/requests"

  model :user
  collection :users
  request :get_current_user
  request :create_user
  request :get_user
  request :get_users
  request :update_user
  request :destroy_user

  recognizes :url, :subdomain, :host, :port, :path, :scheme, :logger, :adapter


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

      @url  = url
      @path = URI.parse(url).path

      logger             = options[:logger]
      adapter            = options[:adapter] || :net_http
      connection_options = options[:connection_options] || {ssl: {verify: false}}
      @username          = options[:username] || Zendesk2.defaults[:username]
      @password          = options[:password] || Zendesk2.defaults[:password]

      raise "Missing required options: [:username, :password]" unless @username && @password

      @connection = Faraday.new({url: @url}.merge(connection_options)) do |builder|
        # response
        builder.use Faraday::Request::BasicAuthentication, @username, @password
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
      url     = File.join(@path, options[:path])
      params  = options[:params] || {}
      body    = options[:body]
      headers = options[:headers] || {}

      @connection.send(method) do |req|
        req.url url
        req.headers.merge!(headers)
        req.params.merge!(params)
        req.body= body
      end
    end

  end

  class Mock

    attr_reader :username, :url

    def self.data
      @data ||= {
        :users => {},
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

      @current_user_id = self.class.new_id

      self.data[:users][@current_user_id]= {
        "id"    => @current_user_id,
        "email" => @username,
        "name"  => "Mock Agent",
        "url"   => File.join(@url, "/users/#{@current_user_id}.json"),
      }
    end

    def response(options={})
      method = options[:method] || :get
      status = options[:status] || 200
      path   = options[:path]
      body   = options[:body]

      url = File.join(@url, path)

      Faraday::Response.new(
        :method          => method,
        :status          => status,
        :url             => url,
        :body            => body,
        :request_headers => {
          "Content-Type"   => "application/json"
        },
      )
    end
  end
end
