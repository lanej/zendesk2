class Zendesk2::Client
  class Real
    def get_topic_comments(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/topic_comments.json",
      )
    end
  end
  class Mock
    def get_topic_comments(params={})
      page(params, :topic_comments, "/topic_comments.json", "topic_comments")
    end
  end
end
