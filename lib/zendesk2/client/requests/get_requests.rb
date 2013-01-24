class Zendesk2::Client
  class Real
    def get_requests(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/requests.json",
      )
    end
  end
  class Mock
    def get_requests(params={})
      page(params, :requests, "/requests.json", "requests")
    end
  end
end
