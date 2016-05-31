# frozen_string_literal: true
class Zendesk2::GetAssignableGroups
  include Zendesk2::Request

  request_method :get
  request_path do |_r| '/groups/assignable.json' end

  page_params!

  def mock
    groups = cistern.data[:groups].values.select { |group| group.select { |g| !g['deleted'] } }

    page(groups, root: 'groups')
  end
end
