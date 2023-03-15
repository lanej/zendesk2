# frozen_string_literal: true
class Zendesk2::Error < StandardError
  attr_reader :wrapped_exception, :response
  def initialize(wrapped_exception)
    @wrapped_exception = wrapped_exception
    @response = wrapped_exception.response
    message = 
      if wrapped_exception.is_a?(Faraday::Error::ParsingError)
        wrapped_exception.message
      elsif wrapped_exception.is_a?(Faraday::Error::ClientError) || wrapped_exception.is_a?(Faraday::ClientError)
        wrapped_exception.response.inspect
      else
        wrapped_exception.instance_variable_get(:@wrapped_exception)
      end
    super(message)
  end
end
