# frozen_string_literal: true
class Zendesk2::CreateOrganization
  include Zendesk2::Request

  request_method :post
  request_path do |_| '/organizations.json' end
  request_body do |r| { 'organization' => r.organization_params } end

  def self.accepted_attributes
    %w(details domain_names external_id group_id organization_fields shared_comments shared_tickets tags name notes)
  end

  def organization_params
    @_organization_params ||= Cistern::Hash.slice(params.fetch('organization'), *self.class.accepted_attributes)
  end

  def mock
    identity = cistern.serial_id

    record = {
      'id'         => identity,
      'url'        => url_for("/organizations/#{identity}.json"),
      'created_at' => Time.now.iso8601,
      'updated_at' => Time.now.iso8601,
    }.merge(organization_params)

    unless record['name']
      error!(:invalid, details: { 'name' => [{ 'description' => 'Name cannot be blank' }] })
    end

    if data[:organizations].values.find { |o| o['name'].casecmp(record['name'].downcase).zero? }
      error!(:invalid, details: { 'name' => [{ 'description' => 'Name: has already been taken' }] })
    end

    external_id = record['external_id']
    matching_organization = external_id && data[:organizations].values.find { |o|
      o['external_id'].to_s.casecmp(external_id.to_s.downcase).zero?
    }

    if matching_organization
      error!(:invalid, details: { 'name' => [{ 'description' => 'External has already been taken' }] })
    end

    data[:organizations][identity] = record

    mock_response({ 'organization' => record }, { status: 201 })
  end
end
