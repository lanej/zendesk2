class Zendesk2::Client
  class Real
    def get_assignable_groups(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/groups/assignable.json",
      )
    end
  end
  class Mock
    def get_assignable_groups(params={})
      filter = lambda { |group| group.select{|g| !g['deleted'] } }

      page(params, :groups, "/groups/assignable.json", "groups", filter: filter)
    end
  end
end
