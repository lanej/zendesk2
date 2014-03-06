class Zendesk2::Client
  class Real
    def create_user_field(params={})
      request(
        :body   => {"user_field" => params},
        :method => :post,
        :path   => "/user_fields.json",
      )
    end
  end # Real

  class Mock
    def create_user_field(params={})
      identity = self.class.new_id

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
      }.merge(params)

      self.data[:user_fields][identity] = record

      response(
        :method => :post,
        :body   => {"user_field" => record},
        :path   => "/user_fields.json"
      )
    end
  end # Mock
end # Zendesk2::Client
