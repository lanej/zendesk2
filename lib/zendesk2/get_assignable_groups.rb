class Zendesk2::GetAssignableGroups < Zendesk2::Request
  request_method :get
  request_path { |r| "/groups/assignable.json" }

  page_params!

  def mock
    groups = service.data[:groups].values.select { |group| group.select { |g| !g['deleted'] } }

    page(groups, root: "groups")
  end
end
