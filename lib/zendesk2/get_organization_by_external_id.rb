class Zendesk2::GetOrganizationByExternalId < Zendesk2::Request
  request_method :get
  request_params { |r| { "external_id" => r.external_id } }
  request_path   { |_| "/organizations/search.json" }

  def external_id
    params.fetch("external_id")
  end

  def mock
    results = self.data[:organizations].select { |k,v| v["external_id"].to_s.downcase == external_id.to_s.downcase }.values

    mock_response("organizations" => results)
  end
end
