class Zendesk2::CreateOrganization < Zendesk2::Request
  request_method :post
  request_path { |_| "/organizations.json" }
  request_body { |r|  { "organization" => r.organization_params } }

  def self.accepted_attributes
    %w[details domain_names external_id group_id organization_fields shared_comments shared_tickets tags name notes]
  end

  def organization_params
    @_organization_params ||= Cistern::Hash.slice(params.fetch("organization"), *self.class.accepted_attributes)
  end

  def mock
    identity = service.serial_id

    record = {
      "id"         => identity,
      "url"        => url_for("/organizations/#{identity}.json"),
      "created_at" => Time.now.iso8601,
      "updated_at" => Time.now.iso8601,
    }.merge(self.organization_params)

    unless record["name"]
      error!(:invalid, details: { "name" => [ { "description" => "Name cannot be blank" } ]})
    end

    if self.data[:organizations].values.find { |o| o["name"].downcase == record["name"].downcase }
      error!(:invalid, details: {"name" => [ { "description" => "Name: has already been taken" } ]})
    end

    if record["external_id"] && self.data[:organizations].values.find { |o| o["external_id"].to_s.downcase == record["external_id"].to_s.downcase }
      error!(:invalid, details: {"name" => [ { "description" => "External has already been taken" } ]})
    end

    self.data[:organizations][identity] = record

    mock_response({"organization" => record}, {status: 201})
  end
end
