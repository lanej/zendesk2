class Zendesk2::Client
  class Real
    def create_topic_comment(params={})
      topic_id = params.delete("topic_id")
      request(
        :body   => {"topic_comment" => params},
        :method => :post,
        :path   => "/topics/#{topic_id}/comments.json",
      )
    end
  end # Real

  class Mock
    def create_topic_comment(params={})
      identity = self.class.new_id

      record = {
        "id"         => identity,
        "url"        => url_for("/topic_comments/#{identity}.json"),
        "created_at" => Time.now.iso8601,
        "updated_at" => Time.now.iso8601,
      }.merge(params)

      path = "/topic_comments.json"
      self.data[:topic_comments][identity]= record

      response(
        :method => :post,
        :body   => {"topic_comment" => record},
        :path   => path,
      )
    end
  end # Mock
end
