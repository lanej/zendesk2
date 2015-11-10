class Zendesk2::CreateHelpCenterCategory < Zendesk2::Request
  request_method :post
  request_path { |_| "/help_center/categories.json" }
  request_body { |r| {"category" => r.category_params} }

  def self.accepted_attributes
    %w[category_id description locale name position sorting]
  end

  def category_params
    Cistern::Hash.slice(params.fetch("category"), *self.class.accepted_attributes)
  end

  def mock
    identity = service.serial_id

    locale = params["locale"] ||= "en-us"
    position = self.data[:help_center_categories].size

    record = {
      "id"          => identity,
      "url"         => url_for("/help_center/#{locale}/categories/#{identity}.json"),
      "html_url"    => html_url_for("/hc/#{locale}/categories/#{identity}.json"),
      "author_id"   => service.current_user["id"],
      "position"    => position,
      "created_at"  => Time.now.iso8601,
      "updated_at"  => Time.now.iso8601,
      "description" => "",
    }.merge(category_params)

    self.data[:help_center_categories][identity] = record

    mock_response("category" => record)
  end
end
