class Zendesk2::Client
  class Real
    def get_topic_comment(params={})
      id       = params["id"]
      topic_id = params["topic_id"]
      path     = "/topics/#{topic_id}/comments/#{id}.json"

      request(
        :method => :get,
        :path => path,
      )
    end
  end # Real

  class Mock
    def get_topic_comment(params={})
      id       = params["id"]
      topic_id = params["topic_id"]
      path     = "/topics/#{topic_id}/comments/#{id}.json"

      body = self.data[:topic_comments][id]

      unless (topic_comment = self.data[:topic_comments][id]) && topic_comment["topic_id"] == topic_id
        response(status: 404)
      else
        response(
          :path  => "/topic_comments/#{id}.json",
          :body  => {
            "topic_comment" => topic_comment,
          },
        )
      end
    end
  end # Mock
end
