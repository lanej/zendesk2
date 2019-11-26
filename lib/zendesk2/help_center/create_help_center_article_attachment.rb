class Zendesk2::CreateHelpCenterArticleAttachment
  include Zendesk2::Request
  request_method :post

  request_path do |r|
    "/help_center/articles/#{r.article_id}/attachments.json"
  end

  def article_id
    params.fetch('article_id')
  end
end
