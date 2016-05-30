# frozen_string_literal: true
class Zendesk2::TicketChange < Zendesk2::AuditEvent
  # @return [Integer] Automatically assigned when creating events
  identity :id, type: :integer

  # @return [String] The name of the field that was changed
  attribute :field_name, type: :string
  # @return [String] The name of the field that was changed
  attribute :value, type: :string
  # @return [Array] The previous value of the field that was changed
  attribute :previous_value, type: :array, parser: ->(v, _) { [*v] }
end
