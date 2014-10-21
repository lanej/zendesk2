class Zendesk2::Client::GetOrganizationByExternalId < Zendesk2::Client::Request
  request_method :get
  request_params { |r| { "external_id" => r.external_id } }
  request_path   { |_| "/organizations/search.json" }

  def external_id
    params.fetch("external_id")
  end

  def mock
    results = self.data[:organizations].select { |k,v| v["external_id"].to_s == external_id.to_s }.values

    mock_response("organizations" => results)
  end
end
