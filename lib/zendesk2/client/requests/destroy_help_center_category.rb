class Zendesk2::Client
  class Real
    def destroy_help_center_category(id)
      request(
        :method => :delete,
        :path   => "/help_center/categories/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_help_center_category(id)
      response(
        :method => :delete,
        :path   => "/help_center/categories/#{id}.json",
        :body   => {
          "category" => self.find!(:help_center_categories, id),
        },
      )
    end
  end
end
