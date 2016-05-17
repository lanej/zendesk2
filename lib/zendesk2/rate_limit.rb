require "logger"

class Zendesk2::RateLimit

  attr_reader :logger

  def initialize(app, options={})
    @app    = app
    @logger = options[:logger] || ::Logger.new(nil)
  end

  def call(env)
    original_env = env.dup
    response = @app.call(env)

    if response.env[:status] == 429
      delay = (response.env[:response_headers][:retry_after]).to_f
      logger.warn "Rate limited! Retrying after #{delay} seconds."

      sleep(delay)

      call(original_env).tap { |r| increment(r, delay) }
    else
      response
    end
  end

  private

  def increment(response, delay)
    existing_delay = response.headers[:rate_limits] || 0.0
    response.headers[:rate_limits] = existing_delay.to_f + delay.to_f
  end
end
