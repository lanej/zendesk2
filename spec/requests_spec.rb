require 'spec_helper'

describe "requests" do
  let(:client) { create_client }

  it_should_behave_like "a resource", :requests,
    lambda { {subject: Zendesk2.uuid, description: Zendesk2.uuid} },
    lambda { {description: Zendesk2.uuid} }

  describe "with a created request" do
    let(:request) { client.requests.create!(requester: client.users.current, subject: Zendesk2.uuid, description: Zendesk2.uuid) }

    it "should get requester" do
      request.requester.should == client.users.current
    end

    it "should get organization" do
      request.organization.should == client.users.current.organization
    end
  end
end
