class Zendesk2::CreateUserField < Zendesk2::Request
  request_method :post
  request_path { |_| "/user_fields.json" }
  request_body { |r| { "user_field" => r.user_field_params } }

  def self.accepted_attributes
    %w[key type title description position active, regexp_for_validation tag custom_field_options]
  end

  def user_field_params
    Cistern::Hash.slice(params.fetch("user_field"), *self.class.accepted_attributes)
  end

  def mock
    identity = service.serial_id

    record = {
      "active"                => true,
      "collapsed_for_agents"  => false,
      "created_at"            => Time.now.iso8601,
      "description"           => params["title"],
      "editable_in_portal"    => false,
      "id"                    => identity,
      "position"              => 9999,
      "regexp_for_validation" => "",
      "removable"             => true,
      "required"              => false,
      "required_in_portal"    => false,
      "tag"                   => "",
      "title_in_portal"       => params["title"],
      "updated_at"            => Time.now.iso8601,
      "url"                   => url_for("/user_fields/#{identity}.json"),
      "visible_in_portal"     => false,
    }.merge(user_field_params)

    service.data[:user_fields][identity] = record

    mock_response("user_field" => record)
  end
end
