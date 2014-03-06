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

      unless (topic_comment = self.find!(:topic_comments, id)) && topic_comment["topic_id"] == topic_id
        error!(:not_found)
      else
        response(
          :path  => "/topics/#{topic_id}/comments/#{id}.json",
          :body  => {
            "topic_comment" => topic_comment,
          },
        )
      end
    end
  end # Mock
end
