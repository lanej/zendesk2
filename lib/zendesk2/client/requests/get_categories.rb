class Zendesk2::Client
  class Real
    def get_categories(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/categories.json",
      )
    end
  end
  class Mock
    def get_categories(params={})
      page(params, :categories, "/categories.json", "categories")
    end
  end
end
