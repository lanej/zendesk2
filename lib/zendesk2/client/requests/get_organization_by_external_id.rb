class Zendesk2::Client
  class Real
    def get_organization_by_external_id(external_id)
      request(
        :method => :get,
        :params => { external_id: external_id },
        :path   => "/organizations/search.json",
      )
    end
  end # Real

  class Mock
    def get_organization_by_external_id(external_id)
      collection = self.data[:organizations]

      results = collection.select { |k,v| v["external_id"].to_s == external_id.to_s }.values

      response(
        :path => "/organizations/search.json",
        :body => {"organizations" => results},
      )
    end
  end # Mock
end
