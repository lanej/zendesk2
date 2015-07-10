require 'spec_helper'

describe Zendesk2::Client do
  let(:client) { create_client }

  describe "views" do
    let!(:organization) { client.organizations.create!(name: mock_uuid) }

    include_examples "zendesk#resource", {
      :collection    => lambda { client.views },
      :create_params => lambda {
        {
          :title      => mock_uuid,
          :conditions => {
            "any" => [ {"field" => "organization_id", "operator" => "is", "value" => organization.identity.to_s } ],
            "all" => [ {"field" => "status",          "operator" => "is", "value" => "pending"                  } ],
          }
        }
      },
      :update_params => lambda { { title: mock_uuid } },
      :search        => false,
    }
  end
end
