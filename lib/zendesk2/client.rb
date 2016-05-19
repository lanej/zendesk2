# @deprecated use {#Zendesk2}
module Zendesk2::Client
  def self.method_missing(message, *args, &block)
    Cistern.deprecation("Zendesk2::Client is deprecated, use Zendesk2", caller[1])

    if Zendesk2.respond_to?(message)
      Zendesk2.public_send(message, *args, &block)
    else
      super
    end
  end

  def self.respond_to?(message)
    Cistern.deprecation("Zendesk2::Client is deprecated, use Zendesk2", caller[1])

    Zendesk2.respond_to?(message) || super
  end
end

