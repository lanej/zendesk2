# frozen_string_literal: true
class Zendesk2::GetTickets
  include Zendesk2::Request

  request_method :get
  request_path do |_r| '/tickets.json' end

  page_params!

  def mock
    page(:tickets)
  end
end
