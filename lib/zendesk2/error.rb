class Zendesk2::Error < StandardError

  attr_reader :message
  def initialize(exception)
    @exception = exception
    message = if exception.response
                 "#{exception.response[:status]} #{exception.response[:body]}"
               else
                 exception.message
               end
    super(message)
  end
end
