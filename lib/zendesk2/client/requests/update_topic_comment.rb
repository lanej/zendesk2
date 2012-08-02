class Zendesk2::Client
  class Real
    def update_topic_comment(params={})
      id = params.delete("id")

      request(
        :method => :put,
        :path   => "/topic_comments/#{id}.json",
        :body   => {
          "topic_comment" => params
        },
      )
    end
  end
  class Mock
    def update_topic_comment(params={})
      id   = params.delete("id")
      path = "/topic_comments/#{id}.json"

      body = self.data[:topic_comments][id].merge!(params)
      response(
        :method => :put,
        :path   => path,
        :body   => {
          "topic_comment" => body
        },
      )
    end
  end
end
