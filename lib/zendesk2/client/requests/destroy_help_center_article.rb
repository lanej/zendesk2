class Zendesk2::Client
  class Real
    def destroy_help_center_article(id)
      request(
        :method => :delete,
        :path   => "/help_center/articles/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_help_center_article(id)
      response(
        :method => :delete,
        :path   => "/help_center/articles/#{id}.json",
        :body   => {
          "article" => self.find!(:help_center_articles, id),
        },
      )
    end
  end
end
