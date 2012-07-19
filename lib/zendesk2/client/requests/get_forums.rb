class Zendesk2::Client
  class Real
    def get_forums(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/forums.json",
      )
    end
  end
  class Mock
    def get_forums(params={})
      page(params, :forums, "/forums.json", "forums")
    end
  end
end
