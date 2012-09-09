require 'spec_helper'

describe "tickets" do
  let(:client) { create_client }
  it_should_behave_like "a resource", 
    :tickets,
    lambda { {subject: Zendesk2.uuid, description: Zendesk2.uuid} },
    lambda { {subject: Zendesk2.uuid} }

  describe "with a created ticket" do
    let(:ticket) { client.tickets.create(subject: Zendesk2.uuid, description: Zendesk2.uuid) }
    it "should get requester" do
      ticket.requester.should == client.users.current
    end

    it "should get submitter" do
      ticket.submitter.should == client.users.current
    end
  end
end
