class Zendesk2::Client
  class Real
    def create_organization(params={})
      request(
        :body   => {"organization" => params},
        :method => :post,
        :path   => "/organizations.json",
      )
    end
  end # Real

  class Mock
    def create_organization(params={})
      identity = self.class.new_id

      record = {
        "id"         => identity,
        "url"        => url_for("/organizations/#{identity}.json"),
        "created_at" => Time.now.iso8601,
        "updated_at" => Time.now.iso8601,
      }.merge(params)

      unless record["name"]
        response(
          :status  => 422,
          :headers => {
            "status" => "422 Unprocessable Entity",
          },
          :body => {
            "error"       => "RecordInvalid",
            "description" => "Record validation errors",
            "details"     => {
              "name" => [
                {
                  "description" => "Name cannot be blank"
                }
              ]
            }
          }
        )
      end

      if self.data[:organizations].values.find{|o| o["name"] == record["name"]}
        response(
          :status  => 422,
          :headers => {
            "status" => "422 Unprocessable Entity",
          },
          :body    => {
            "error"       => "RecordInvalid",
            "description" => "Record validation errors",
            "details"     => {
              "name" => [
                {
                  "description" => "Name has already been taken"
                }
              ]
            }
          }
        )
      end


      self.data[:organizations][identity]= record

      response(
        :method => :post,
        :body   => {"organization" => record},
        :path   => "/organizations.json"
      )
    end
  end # Mock
end
