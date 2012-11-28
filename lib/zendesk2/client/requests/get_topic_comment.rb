class Zendesk2::Client
  class Real
    def get_topic_comment(params={})
      id       = params["id"]
      topic_id = params["topic_id"]

      request(
        :method => :get,
        :path => "/topics/#{topic_id}/comments/#{id}.json"
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
