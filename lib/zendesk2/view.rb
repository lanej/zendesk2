class Zendesk2::View < Zendesk2::Model
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
    requires :execution, :title

    params = {
      "title"  => self.title,
      "active" => self.active,
      "output" => Cistern::Hash.slice(self.execution, "sort_by", "sort_order", "group_by", "group_order", "columns")
    }.merge(Cistern::Hash.slice(self.conditions, "any", "all"))

    data = if new_record?
             service.create_view("view" => params)
           else
             service.create_view("view" => params)
           end.body

    merge_attributes(data["view"])
  end

  def tickets
    requires :identity

    service.tickets(view_id: self.identity)
  end

  def destroy!
    requires :identity

    service.destroy_view("view" => {"id" => self.identity})
  end
end
