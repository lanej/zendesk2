class Zendesk2::Client
  class Real
    def get_help_center_articles(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/help_center/articles.json",
      )
    end
  end
  class Mock
    def get_help_center_articles(params={})
      page(params, :help_center_articles, "/help_center_articles.json", "articles")
    end
  end
end
