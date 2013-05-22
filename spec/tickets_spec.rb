require 'spec_helper'

describe "tickets" do
  let(:client) { create_client }
  it_should_behave_like "a resource",
    :tickets,
    lambda { {subject: Zendesk2.uuid, description: Zendesk2.uuid} },
    lambda { {subject: Zendesk2.uuid} }

  describe "when creating a ticket" do
    let(:ticket) { client.create_ticket(subject: Zendesk2.uuid, description: Zendesk2.uuid, 'requester' => {'email' => "newuser@example.org"}) }
    it "should create requester" do
      ticket.body["ticket"]["requester_id"].should_not == client.users.current.id
    end
  end

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

    it "lists audits" do
      body = Zendesk2.uuid
      ticket.comment(body)

      audit = ticket.audits.last
      audit.ticket.should == ticket

      events = audit.events
      events.size.should == 1

      event = events.first
      event.body.should == body
      event.should be_a(Zendesk2::Client::TicketComment)
      event.ticket_audit.should == audit
    end

    it "lists comments" do
      body = Zendesk2.uuid
      ticket.comment(body)

      (comment = ticket.comments.find{|c| c.body == body}).should_not be_nil
    end
  end
end
