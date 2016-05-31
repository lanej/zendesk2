# frozen_string_literal: true
class Zendesk2::GetOrganizationByExternalId
  include Zendesk2::Request

  request_method :get
  request_params do |r| { 'external_id' => r.external_id } end
  request_path   do |_| '/organizations/search.json' end

  def external_id
    params.fetch('external_id')
  end

  def mock
    results = data[:organizations].select { |_k, v|
      v['external_id'].to_s.casecmp(external_id.to_s.downcase).zero?
    }.values

    mock_response('organizations' => results)
  end
end
