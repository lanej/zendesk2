module Zendesk2::Errors
  def not_found
    Faraday::Error::ResourceNotFound
  end

  def not_found!(*args)
    not_found.new(args)
  end

  def unprocessable_entity
    Faraday::Error::ClientError
  end

  def unprocessable_entity!(*args)
    unprocessable_entity.new(args)
  end
end
