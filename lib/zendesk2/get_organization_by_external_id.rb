# frozen_string_literal: true
class Zendesk2::GetOrganizationByExternalId
  include Zendesk2::Request

  request_method :get
  request_params { |r| { 'external_id' => r.external_id } }
  request_path   { |_| '/organizations/search.json' }

  def external_id
    params.fetch('external_id')
  end

  def mock
    results = data[:organizations].select do |_k, v|
      v['external_id'].to_s.casecmp(external_id.to_s.downcase).zero?
    end.values

    mock_response('organizations' => results)
  end
end
