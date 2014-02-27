class Zendesk2::Client
  class Real
    def create_ticket_field(params={})
      request(
        :body   => {"ticket_field" => params},
        :method => :post,
        :path   => "/ticket_fields.json",
      )
    end
  end # Real

  class Mock
    def create_ticket_field(params={})
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
        "url"                   => url_for("/ticket_fields/#{identity}.json"),
        "visible_in_portal"     => false,
      }.merge(params)

      self.data[:ticket_fields][identity] = record

      response(
        :method => :post,
        :body   => {"ticket_field" => record},
        :path   => "/ticket_fields.json"
      )
    end
  end # Mock
end # Zendesk2::Client
