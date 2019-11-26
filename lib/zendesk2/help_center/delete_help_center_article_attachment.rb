class Zendesk2::DeleteHelpCenterArticleAttachment
  include Zendesk2::Request
  request_method :delete

  request_path do |r|
    "/help_center/articles/attachments/#{r.attachment_id}.json"
  end

  def attachment_id
    params.fetch('attachment_id')
  end
end
