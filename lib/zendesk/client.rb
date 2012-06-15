require 'cistern'
require 'faraday'
require 'faraday_middleware'
require 'excon'

require 'formatador'


class Zendesk::Client < Cistern::Service

  model_path "zendesk/models"
  request_path "zendesk/requests"

  model :user
  collection :users
  request :get_current_user
  request :create_user
  request :get_user
  request :get_users
  #request :update_user
  #request :destroy_user
  #

  requires :username, :password

  recognizes :url, :subdomain, :host, :port, :path, :scheme, :logger, :adapter


  class Real

    attr_reader :username, :url

    def initialize(options={})
      url = options[:url] || begin
        host   = options[:host]
        host ||= "#{options[:subdomain]}.zendesk.com"

        path   = options[:path] || "api/v2"
        scheme = options[:scheme] || "https"

        port   = options[:port] || (scheme == "https" ? 443 : 80)

        "#{scheme}://#{host}:#{port}/#{path}"
      end

      @url  = url
      @path = URI.parse(url).path

      logger             = options[:logger]
      adapter            = options[:adapter] || :excon
      @username, @password = options[:username], options[:password]

      @connection = Faraday.new(url: @url) do |builder|
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

    def self.data
      @data ||= {}
    end

    def data
      self.class.data
    end

    def self.reset!
      @data = nil
    end

    def initialize(options={})
    end

  end

end
