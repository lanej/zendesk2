# @abstract subclass and implement audit event specific attributes
class Zendesk2::Client::AuditEvent < Cistern::Model
  extend Zendesk2::Attributes
  extend Forwardable

  def self.all
    @all ||= []
  end

  def self.inherited(klass)
    all << klass
  end

  def self.for(attributes)
    event_class = "Zendesk2::Client::Ticket#{attributes["type"]}"
    if klass = all.find{|k| k.name == event_class}
      klass.new(attributes)
    else # handle unrecognized audit events
      attributes.reject{|k,v| k == :connection}
    end
  end

  # @return [String] has the event value
  attribute :type, type: :string

  # @return [Zendesk2::Client::TicketAudit] audit that includes this event
  attr_accessor :ticket_audit

  def_delegators :ticket_audit, :created_at
end
