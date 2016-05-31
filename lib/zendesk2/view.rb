# frozen_string_literal: true
class Zendesk2::View
  include Zendesk2::Model

  extend Zendesk2::Attributes

  # @return [Integer] Automatically assigned when created
  identity :id, type: :integer

  # @return [Boolean] Useful for determining if the view should be displayed
  attribute :active, type: :boolean
  # @return [Hash] An object describing how the view is constructed
  attribute :conditions, type: :hash, default: {}
  # @return [Time] The time the view was created
  attribute :created_at, type: :time
  # @return [Hash] An object describing how the view should be executed
  attribute :execution, type: :hash, default: {}
  # @return [Hash] Who may access this account. Will be null when everyone in the account can access it.
  attribute :restriction, type: :hash, default: {}
  # @return [Integer] If the view is for an SLA this is the id
  attribute :sla_id, type: :integer
  # @return [String] The title of the view
  attribute :title, type: :string
  # @return [Time] The time of the last update of the view
  attribute :updated_at, type: :time

  def save!
    new_record? ? create : update
  end

  def create
    requires :execution, :title

    data = cistern.create_view('view' => request_data).body
    merge_attributes(data['view'])
  end

  def update
    requires :identity

    data = cistern.update_view('view' => request_data.merge('id' => identity)).body
    merge_attributes(data['view'])
  end

  def tickets
    requires :identity

    cistern.tickets(view_id: identity)
  end

  def destroy!
    requires :identity

    cistern.destroy_view('view' => { 'id' => identity })
  end

  protected

  def request_data
    Cistern::Hash.slice(conditions, 'any', 'all').merge(
      'title' => title,
      'active' => active,
      'output' => Cistern::Hash.slice(execution, 'sort_by', 'sort_order', 'group_by', 'group_order', 'columns')
    )
  end
end
