class Zendesk2::Error < StandardError
  def initialize(exception)
    @exception = exception
    @message = "#{exception.response[:status]} #{exception.response[:body]}"
  end

  def message
    @message
  end
end
