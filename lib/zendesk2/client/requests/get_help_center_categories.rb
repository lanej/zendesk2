class Zendesk2::Client
  class Real
    def get_help_center_categories(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/help_center/categories.json",
      )
    end
  end
  class Mock
    def get_help_center_categories(params={})
      page(params, :help_center_categories, "/help_center_categories.json", "categories")
    end
  end
end
