module Zendesk2::Errors
  def not_found
    Faraday::Error::ResourceNotFound
  end

  def not_found!(*args)
    not_found.new(args)
  end
end
