class Zendesk2::CreateView < Zendesk2::Request
  request_method :post
  request_path { |_| "/views.json" }
  request_body { |r| { "view" => r.view_params } }

  def self.accepted_attributes
    %w[title all any active output restriction]
  end

  def self.view_columns
    @_view_columns ||= {
      "assigned"           => "Assigned date",
      "assignee"           => "Assignee",
      "brand"              => "Brand",
      "created"            => "Request date",
      "description"        => "Subject",
      "due_date"           => "Due Date",
      "group"              => "Group",
      "locale_id"          => "Requester language",
      "nice_id"            => "ID",
      "organization"       => "Organization",
      "priority"           => "Priority",
      "requester"          => "Requester",
      "satisfaction_score" => "Satisfaction",
      "score"              => "Score",
      "solved"             => "Solved date",
      "status"             => "Status",
      "submitter"          => "Submitter",
      "ticket_form"        => "Ticket form",
      "type"               => "Ticket type",
      "updated"            => "Latest update",
      "updated_assignee"   => "Latest update by assignee",
      "updated_by_type"    => "Latest updater type (agent/end-user)",
      "updated_requester"  => "Latest update by requester",
    }.freeze
  end

  def view_params
    @_view_params ||= Cistern::Hash.slice(params.fetch("view"), *self.class.accepted_attributes)
  end

  # {:status=>422, :headers=>{"server"=>"nginx", "date"=>"Fri, 10 Jul 2015 18:58:50 GMT", "content-type"=>"application/json; charset=UTF-8", "content-length"=>"262", "connection"=>"close", "status"=>"422 Unprocessable Entity", "x-zendesk-api-version"=>"v2", "x-frame-options"=>"SAMEORIGIN", "strict-transport-security"=>"max-age=31536000;", "x-ua-compatible"=>"IE=Edge,chrome=1", "cache-control"=>"no-cache", "x-zendesk-origin-server"=>"app5.pod5.iad1.zdsys.com", "x-request-id"=>"8dec47a7-f80d-4823-c8e2-b8ca3a6b1aa9", "x-runtime"=>"0.106400", "x-rack-cache"=>"invalidate, pass", "x-zendesk-request-id"=>"6efea4cc3c46093df8b1"}, :body=>{"error"=>"RecordInvalid", "description"=>"Record validation errors", "details"=>{"base"=>[{"description"=>"View must test for at least <strong>one</strong> of the following ticket properties in the ALL conditions section: Status, Type, Group, Assignee, Requester."}]}}}
  # {:status=>400, :headers=>{"server"=>"nginx", "date"=>"Fri, 10 Jul 2015 18:58:39 GMT", "content-type"=>"application/json; charset=UTF-8", "content-length"=>"142", "connection"=>"close", "status"=>"400 Bad Request", "x-zendesk-api-version"=>"v2", "strict-transport-security"=>"max-age=31536000;", "x-ua-compatible"=>"IE=Edge,chrome=1", "cache-control"=>"no-cache", "x-zendesk-origin-server"=>"app5.pod5.iad1.zdsys.com", "x-request-id"=>"55216728-1c4b-49ce-c988-b8ca3a6b1a09", "x-runtime"=>"0.077761", "x-rack-cache"=>"invalidate, pass", "x-zendesk-request-id"=>"a49e204bdb7ceb6d22b2"}, :body=>{"error"=>{"title"=>"Invalid attribute", "message"=>"You passed an invalid value for the value attribute. must be a string"}}}
  # {:status=>422, :headers=>{"server"=>"nginx", "date"=>"Fri, 10 Jul 2015 18:57:38 GMT", "content-type"=>"application/json; charset=UTF-8", "content-length"=>"326", "connection"=>"close", "status"=>"422 Unprocessable Entity", "x-zendesk-api-version"=>"v2", "x-frame-options"=>"SAMEORIGIN", "strict-transport-security"=>"max-age=31536000;", "x-ua-compatible"=>"IE=Edge,chrome=1", "cache-control"=>"no-cache", "x-zendesk-origin-server"=>"app19.pod5.iad1.zdsys.com", "x-request-id"=>"577927e1-1a98-4642-c636-b8ca3a6bdb18", "x-runtime"=>"0.114688", "x-rack-cache"=>"invalidate, pass", "x-zendesk-request-id"=>"6f646a8ab4e30717d593"}, :body=>{"error"=>"RecordInvalid", "description"=>"Record validation errors", "details"=>{"base"=>[{"description"=>"Organization 1 was deleted and cannot be used"}, {"description"=>"View must test for at least <strong>one</strong> of the following ticket properties in the ALL conditions section: Status, Type, Group, Assignee, Requester."}]}}}
  def mock
    create_params = view_params.dup

    if create_params["title"].nil? || create_params["title"] == ""
      error!(:invalid, :details => {"base" => [{"title" => "Title: cannot be blank"}]})
    end

    if Array(create_params["any"]).empty? && Array(create_params["all"]).empty?
      error!(:invalid, :details => {"base" => ["Invalid conditions: You must select at least one condition"]})
    end

    identity = service.serial_id

    output = view_params.delete("output") || {}
    columns = (output["columns"] || []).inject([]) { |r,c| r << {"id" => c, "name" => self.class.view_columns.fetch(c)} }

    record = {
      "id"               => identity,
      "url"              => url_for("/views/#{identity}.json"),
      "created_at"       => Time.now.iso8601,
      "updated_at"       => Time.now.iso8601,
      "active"           => true,
      "execution"        => {
        "columns"       => columns,
        "fields"        => columns,
        "custom_fields" => [],
        "group_by"      => create_params["group_by"],
        "group_order"   => create_params["group_order"],
        "sort_by"       => create_params["sort_by"],
        "sort_order"    => create_params["sort_order"],
        "sort" => {
          "id"    => create_params["sort_by"],
          "order" => create_params["sort_order"],
          "title" => (create_params["sort_by"] && create_params["sort_by"].to_s.upcase),
        },
        "group" => {
          "id"    => create_params["group_by"],
          "order" => create_params["group_order"],
          "title" => (create_params["group_by"] && create_params["group_by"].to_s.upcase),
        },
      },
      "conditions"    => {
        "any" => Array(create_params["any"]),
        "all" => Array(create_params["all"]),
      },
    }.merge(create_params)

    service.data[:views][identity] = record

    mock_response("view" => record)
  end
end
