class Zendesk2::GetHelpCenterArticleAttachments
  include Zendesk2::Request

  request_path do |r|
    "/help_center/articles/#{r.article_id}/attachments.json"
  end

  def article_id
    params.fetch('article_id')
  end

  def mock
    mock_response('article_attachments' => find!(:help_center_article_attachments, :article_id))
  end
end
