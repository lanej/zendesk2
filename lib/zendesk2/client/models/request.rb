class Zendesk2::Client::Request < Zendesk2::Model
  extend Zendesk2::Attributes

  PARAMS = %w[requester_id subject status custom_fields]

  # @return [Integer] Automatically assigned when creating requests
  identity :id, type: :integer

  # @return [date] When this record was created
  attribute :created_at, type: :time
  # @return [Array] The fields and entries for this request
  attribute :custom_fields, type: :array
  # @return [String] The first comment on the request
  attribute :description, type: :string
  # @return [Integer] The organization of the requester
  attribute :organization_id, type: :integer
  # @return [Integer] The id of the requester
  attribute :requester_id, type: :integer
  # @return [String] The state of the request, "new", "open", "pending", "hold", "solved", "closed"
  attribute :status, type: :string
  # @return [String] The value of the subject field for this request
  attribute :subject, type: :string
  # @return [Time] When this record last got updated
  attribute :updated_at, type: :time
  # @return [String] The API url of this request
  attribute :url, type: :string
  # @return [Via] This object explains how the request was created
  attribute :via

  assoc_accessor :requester, collection: :users
  assoc_accessor :organization

  def save!
    data = if new_record?
             requires :subject, :description
             connection.create_request(params.merge(
               "comment" => {
                 "body" => self.description
               }
             )).body["request"]
           else
             requires :identity
             connection.update_request(params.merge("id" => self.identity)).body["request"]
           end

    merge_attributes(data)
  end

  def destroy
    requires :identity

    connection.destroy_request("id" => self.identity)
  end

  private

  def params
    Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), *PARAMS)
  end
end
