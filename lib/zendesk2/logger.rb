# frozen_string_literal: true
class Zendesk2::Logger < Faraday::Response::Middleware
  extend Forwardable

  def initialize(app, logger = nil)
    super(app)
    @logger = logger || ::Logger.new(STDOUT)
  end

  def_delegators :@logger, :debug, :info, :warn, :error, :fatal

  def call(env)
    info("#{env[:method]} => #{env[:url]}")
    debug('request') do dump_headers env[:request_headers] end
    debug('request.body') do env[:body] end
    super
  end

  def on_complete(env)
    info("#{env[:status]} <= #{env[:url]}")
    debug('response') do dump_headers env[:response_headers] end
    debug('response.body') { env[:body] }
  end

  private

  def dump_headers(headers)
    headers.map { |k, v| "#{k}: #{v.inspect}" }.join("\n")
  end
end
