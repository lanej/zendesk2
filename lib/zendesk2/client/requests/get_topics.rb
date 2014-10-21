class Zendesk2::Client::GetTopics < Zendesk2::Client::Request
  request_path { |r| "/topics.json" }

  page_params!

  def mock
    page(:topics)
  end
end
