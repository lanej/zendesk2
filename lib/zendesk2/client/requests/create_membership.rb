class Zendesk2::Client
  class Real
    def create_membership(params={})
      require_parameters(params, "user_id", "organization_id")

      user_id = params["user_id"]

      request(
        :body   => {"organization_membership" => params },
        :method => :post,
        :path   => "/users/#{user_id}/organization_memberships.json",
      )
    end
  end # Real

  class Mock
    def create_membership(params={})
      require_parameters(params, "user_id", "organization_id")

      user_id         = params["user_id"]
      organization_id = params["organization_id"]

      find!(:users, user_id)
      find!(:organizations, organization_id, error: :invalid, details: { "organization" => [ { "description" => "Organization cannot be blank" } ] })
      if self.data[:memberships].values.find { |m| m["user_id"] == user_id && m["organization_id"] == organization_id }
        error!(:invalid, description: { "user_id" => [ { "description" => "User has already been taken" } ] })
      end

      resource_id = self.class.new_id

      default_membership = false # !self.data[:memberships].values.find { |m| m["user_id"] == user_id && m["default"] }

      resource = {
        "id"              => resource_id,
        "user_id"         => user_id,
        "organization_id" => organization_id,
        "default"         => default_membership,
      }

      self.data[:memberships][resource_id] = resource

      response(
        :method => :post,
        :body   => { "organization_membership" => resource },
        :path   => "/users/#{user_id}/organization_memberships.json",
      )
    end
  end # Mock
end
