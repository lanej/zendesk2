class Zendesk2::Client
  class Real
    def mark_membership_default(params={})
      id      = params.delete("id")
      user_id = params.delete("user_id")

      path = "/users/#{user_id}/organization_memberships/#{id}/make_default.json"

      request(
        :method => :put,
        :path   => path,
      )
    end
  end
  class Mock
    def mark_membership_default(params={})
      id      = params.delete("id")
      user_id = params.delete("user_id")

      path = "/users/#{user_id}/organization_memberships/#{id}/make_default.json"

      if (membership = self.data[:memberships][id]) && membership["user_id"] == user_id
        # only one user can be default
        other_user_memberships = self.data[:memberships].values.select { |m| m["user_id"] == user_id }
        other_user_memberships.each { |i| i["default"] = false }
        membership["default"] = true

        response(
          :method => :put,
          :path   => path
        )
      else
        response(
          :path   => path,
          :status => 404
        )
      end
    end
  end
end
