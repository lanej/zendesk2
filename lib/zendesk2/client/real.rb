class Zendesk2::Client < Cistern::Service
  class Real

    attr_accessor :username, :url, :token, :logger, :jwt_token, :last_request

    def initialize(options={})
      @url = if url = options[:url] || Zendesk2.defaults[:url]
               URI.parse(url).to_s
             end

      @logger   = options[:logger]   || Logger.new(nil)
      adapter   = options[:adapter]  || Faraday.default_adapter
      @username = options[:username] || Zendesk2.defaults[:username]
      @token    = options[:token]    || Zendesk2.defaults[:token]
      password  = options[:password] || Zendesk2.defaults[:password]

      service_options = options[:service_options] || {}

      @auth_token  = password || @token
      @username   += "/token" if @auth_token == @token
      @jwt_token   = options[:jwt_token]

      raise "Missing required options: :url" unless @url
      raise "Missing required options: :username" unless @username
      raise "Missing required options: :password or :token" unless password || @token

      @service = Faraday.new({url: @url}.merge(service_options)) do |builder|
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

      @service.send(method) do |req|
        req.url(url)
        req.headers.merge!(headers)
        req.params.merge!(params)
        req.body = @last_request = body
      end
    rescue Faraday::Error::ClientError => e
      raise Zendesk2::Error.new(e)
    end
  end
end
