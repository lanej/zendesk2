class Zendesk2::Client
  class Real
    def destroy_help_center_section(id)
      request(
        :method => :delete,
        :path   => "/help_center/sections/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_help_center_section(id)
      response(
        :method => :delete,
        :path   => "/help_center/sections/#{id}.json",
        :body   => {
          "section" => self.find!(:help_center_sections, id),
        },
      )
    end
  end
end
