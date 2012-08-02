class Zendesk2::Client
  class Real
    def get_topic_comment(params={})
      id = params["id"]

      request(
        :method => :get,
        :path => "/topic_comments/#{id}.json"
      )
    end
  end # Real

  class Mock
    def get_topic_comment(params={})
      id   = params["id"]
      body = self.data[:topic_comments][id]

      response(
        :path  => "/topic_comments/#{id}.json",
        :body  => {
          "topic_comment" => body
        },
      )
    end
  end # Mock
end
