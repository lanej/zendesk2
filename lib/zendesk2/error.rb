class Zendesk2::Error < StandardError

  attr_reader :message, :wrapped_exception
  def initialize(wrapped_exception)
    @wrapped_exception = wrapped_exception
    @message = if wrapped_exception.is_a?(Faraday::Error::ParsingError)
                wrapped_exception.message
              elsif wrapped_exception.is_a?(Faraday::Error::ClientError)
                wrapped_exception.response.inspect
              else
                wrapped_exception.instance_variable_get(:@wrapped_exception).inspect
              end
  end
end
