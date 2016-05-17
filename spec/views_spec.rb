require 'spec_helper'

describe Zendesk2 do
  let(:client) { create_client }

  context "with an organization" do
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

    context "and a view that filters by that organization" do
      let!(:user) { client.users.create!(email: mock_email, name: mock_uuid, verified: true) }
      let!(:view) {
        client.views.create!(
          :title      => mock_uuid,
          :conditions => {
            "all" => [ {"field" => "organization_id", "operator" => "is", "value" => organization.identity.to_s } ],
          }
        )
      }

      before {
        client.memberships.create(user: user, organization: organization)
      }

      let!(:tickets) {
        2.times.map {
          client.tickets.create!(subject: mock_uuid, description: mock_uuid, requester: user, organization: organization)
        }
      }

      before {
        another_organization =  client.organizations.create!(name: mock_uuid)
        another_user         = client.users.create!(email: mock_email, name: mock_uuid, verified: true)

        client.memberships.create(user: another_user, organization: another_organization)

        2.times.each {
          client.tickets.create!(subject: mock_uuid, description: mock_uuid, requester: another_user)
        }
      }

      it "should find only that organizations tickets" do
        expect(view.tickets).to match_array(tickets)
      end
    end
  end
end
