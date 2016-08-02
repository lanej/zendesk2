# frozen_string_literal: true
# @deprecated use {#Zendesk2}
module Zendesk2::Client
  class << self
    def respond_to_missing?(method, *)
      Zendesk2.respond_to?(method) || super
    end

    def method_missing(message, *args, &block)
      Cistern.deprecation('Zendesk2::Client is deprecated, use Zendesk2', caller[1])

      if Zendesk2.respond_to?(message)
        Zendesk2.public_send(message, *args, &block)
      else
        super
      end
    end
  end
end
