class Zendesk2::Client
  class Real
    def get_topic_comments(params={})
      topic_id    = params.delete("topic_id")
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params => page_params,
        :path   => "/topics/#{topic_id}/comments.json",
      )
    end
  end
  class Mock
    def get_topic_comments(params={})
      topic_id = params["topic_id"]
      topic    = self.data[:topics][topic_id] # TODO: 404 if !topic
      filter   = lambda{|comments| comments.select{|c| c["topic_id"] == topic_id}}

      page(params, :topic_comments, "/topics/#{topic_id}/comments.json", "topic_comments", filter: filter)
    end
  end
end
