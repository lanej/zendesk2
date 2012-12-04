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

  describe "comments" do
    let(:ticket) { client.tickets.create(subject: Zendesk2.uuid, description: Zendesk2.uuid) }
    before(:each) { client.data[:ticket_audits] = {} }

    it "lists audits" do
      ticket.audits.size.should == 0
      client.data[:ticket_audits][1] = {'ticket_id' => ticket.id}
      ticket.audits.size.should == 1
    end

    it "lists comments" do
      ticket.comments.size.should == 0
      client.data[:ticket_audits][2] = {'ticket_id' => ticket.id, 'type' => 'Comment'}
      client.data[:ticket_audits][3] = {'ticket_id' => ticket.id, 'type' => 'Change'}
      ticket.comments.size.should == 1
    end
  end
end
