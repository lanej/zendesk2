class Zendesk2::Client
  class Real
    def destroy_topic_comment(params={})
      id       = params["id"]
      topic_id = params["topic_id"]

      request(
        :method => :delete,
        :path => "/topics/#{topic_id}/comments/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_topic_comment(params={})
      id       = params["id"]
      topic_id = params["topic_id"]
      path     = "/topics/#{topic_id}/comments/#{id}.json"

      body = self.data[:topic_comments].delete(id)
      response(
        :method => :delete,
        :path   => path,
        :body   => {
          "topic_comment" => body,
        },
      )
    end
  end
end
