# frozen_string_literal: true
# @abstract subclass and implement audit event specific attributes
class Zendesk2::AuditEvent
  include Zendesk2::Model

  extend Zendesk2::Attributes
  extend Forwardable

  def self.all
    @all ||= []
  end

  def self.inherited(klass)
    all << klass
  end

  def self.for(attributes)
    event_class = "Zendesk2::Ticket#{attributes['type']}"
    klass = all.find { |k| k.name == event_class }
    if klass
      klass.new(attributes)
    else # handle unrecognized audit events
      attributes.reject { |k, _v| k == :cistern }
    end
  end

  # @return [String] has the event value
  attribute :type, type: :string

  # @return [Zendesk2::TicketAudit] audit that includes this event
  attr_accessor :ticket_audit

  def_delegators :ticket_audit, :created_at
end
