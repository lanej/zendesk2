class Zendesk2::Client
  class Real
    def mark_user_identity_primary(params={})
      id      = params.delete("id")
      user_id = params.delete("user_id")
      path    = "/users/#{user_id}/identities/#{id}/make_primary.json"

      request(
        :method => :put,
        :path   => path,
      )
    end
  end
  class Mock
    def mark_user_identity_primary(params={})
      id      = params.delete("id").to_s
      user_id = params.delete("user_id").to_s
      path    = "/users/#{user_id}/identities/#{id}/make_primary.json"

      user_identity = self.find!(:identities, id)

      if user_identity && user_identity["user_id"] == user_id
        # only one user can be primary
        other_user_identities = self.data[:identities].values.select{|i| i["user_id"] == user_id}
        other_user_identities.map{|i| i["primary"] = false}
        user_identity["primary"] = true

        response(
          :method => :put,
          :path   => path
        )
      else
        error!(:not_found)
      end
    end
  end
end
