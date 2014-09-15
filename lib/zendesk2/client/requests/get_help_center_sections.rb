class Zendesk2::Client
  class Real
    def get_help_center_sections(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/help_center/sections.json",
      )
    end
  end
  class Mock
    def get_help_center_sections(params={})
      page(params, :help_center_sections, "/help_center_sections.json", "sections")
    end
  end
end
