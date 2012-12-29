class Zendesk2::Client
  class Real
    def update_topic_comment(params={})
      id       = params.delete("id")
      topic_id = params.delete("topic_id")
      path     = "/topics/#{topic_id}/comments/#{id}.json"

      request(
        :method => :put,
        :path   => path,
        :body   => {
          "topic_comment" => params
        },
      )
    end
  end
  class Mock
    def update_topic_comment(params={})
      id       = params.delete("id")
      topic_id = params.delete("topic_id")
      path     = "/topics/#{topic_id}/comments/#{id}.json"

      unless (topic_comment = self.data[:topic_comments][id]) && topic_comment["topic_id"] == topic_id
        response(status: 404)
      else
        body = topic_comment.merge!(params)
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
end
