class Zendesk2
  class Real
    def get_user_fields(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/user_fields.json",
      )
    end
  end
  class Mock
    def get_user_fields(params={})
      collection(:user_fields, "/user_fields.json", "user_fields")
    end
  end
end
