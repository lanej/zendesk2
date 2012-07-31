class Zendesk2::Client
  class Real
    def get_topics(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/topics.json",
      )
    end
  end
  class Mock
    def get_topics(params={})
      page(params, :topics, "/topics.json", "topics")
    end
  end
end
