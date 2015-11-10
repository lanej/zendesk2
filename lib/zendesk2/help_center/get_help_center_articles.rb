class Zendesk2::GetHelpCenterArticles < Zendesk2::Request
  request_path { |_| "/help_center/articles.json" }

  page_params!

  def mock
    page(:help_center_articles, root: "articles")
  end
end
