require 'spec_helper'

describe "tickets" do
  let(:client) { create_client }
  it_should_behave_like "a resource", :tickets,
    lambda { {subject: Zendesk2.uuid, description: Zendesk2.uuid} },
    lambda { {subject: Zendesk2.uuid} }

  describe "when creating a ticket" do
    let!(:requester_email) { "#{Zendesk2.uuid}@example.org" }

    it "should create requester" do
      ticket = client.tickets.create!(subject: Zendesk2.uuid, description: Zendesk2.uuid, requester: {name: "Josh Lane", email: requester_email})
      if Zendesk2::Client.mocking? # this takes some time for realsies
        requester = client.users.search(email: requester_email).first
        requester.should_not be_nil

        ticket.reload.requester.should == requester
      else
        ticket.reload.requester.should_not be_nil
      end
    end

    it "should require requester name" do
      expect {
        client.tickets.create!(subject: Zendesk2.uuid, description: Zendesk2.uuid, requester: {email: requester_email})
      }.to raise_exception(Zendesk2::Error, /Requester Name: .* too short/)
    end
  end

  describe "with a created ticket" do
    let(:ticket) { client.tickets.create!(subject: Zendesk2.uuid, description: Zendesk2.uuid) }
    it "should get requester" do
      ticket.requester.should == client.users.current
    end

    it "should get submitter" do
      ticket.submitter.should == client.users.current
    end

    it "should have empty custom fields by default" do
      pending if !Zendesk2::Client.mocking?

      ticket.custom_fields.should == []
    end
  end

  describe "comments" do
    let(:ticket) { client.tickets.create!(subject: Zendesk2.uuid, description: Zendesk2.uuid) }

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

      ticket.comments.find{|c| c.body == body}.should_not be_nil
    end
  end

  describe "custom fields" do
    let!(:ticket_field) { client.ticket_fields.create!(title: Zendesk2.uuid, type: "textbox") }

    it "should be based on ticket_fields" do
      ticket = client.tickets.create!(subject: Zendesk2.uuid, description: Zendesk2.uuid)
      custom_field = ticket.custom_fields.find { |cf| cf["id"] == ticket_field.identity }
      custom_field.should_not be_nil
      custom_field["value"].should be_nil

      ticket = client.tickets.create!(subject: Zendesk2.uuid, description: Zendesk2.uuid, custom_fields: [{"id" => ticket_field.identity, "value" => "jessicaspacekat"}])
      custom_field = ticket.custom_fields.find { |cf| cf["id"] == ticket_field.identity }
      custom_field.should_not be_nil
      custom_field["value"].should == "jessicaspacekat"
    end
  end
end
