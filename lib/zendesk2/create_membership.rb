class Zendesk2::CreateMembership < Zendesk2::Request
  request_method :post
  request_path { |r|  "/users/#{r.user_id}/organization_memberships.json" }
  request_body { |r| { "organization_membership" => r.membership_params } }

  def self.accepted_params
    %w[user_id organization_id default]
  end

  def membership_params
    @_membership_params ||= Cistern::Hash.slice(params.fetch("membership"), *self.class.accepted_params)
  end

  def user_id
    params.fetch("membership").fetch("user_id").to_i
  end

  def organization_id
    params.fetch("membership").fetch("organization_id").to_i
  end

  def mock
    user = find!(:users, user_id)
    find!(:organizations, organization_id,
          :error   => :invalid,
          :details => {
            "organization" => [ { "description" => "Organization cannot be blank" } ],
          })

    if self.data[:memberships].values.find { |m| m["user_id"] == user_id && m["organization_id"] == organization_id }
      error!(:invalid, description: { "user_id" => [ { "description" => "User has already been taken" } ] })
    end

    resource_id = service.serial_id

    default_membership = !self.data[:memberships].values.find { |m| m["user_id"] == user_id && m["default"] }

    resource = {
      "id"              => resource_id,
      "user_id"         => user_id,
      "organization_id" => organization_id,
      "default"         => default_membership,
    }

    self.data[:memberships][resource_id] = resource

    primary_organization = self.data[:memberships].values.find { |m| m["user_id"] == user_id && m["default"] }

    if primary_organization
      user.merge!("organization_id" => primary_organization["organization_id"])
    end

    mock_response("organization_membership" => resource)
  end
end
