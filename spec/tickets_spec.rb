require 'spec_helper'

describe "Zendesk2::Client" do
  let(:client) { create_client }

  describe "tickets" do
    include_examples "zendesk resource", {
      :collection    => lambda { client.tickets },
      :create_params => lambda { {subject: mock_uuid, description: mock_uuid} },
      :update_params => lambda { {subject: mock_uuid} },
    }
  end

  describe "#create_ticket" do
    it "should require a description" do
      expect {
        client.create_ticket("subject" => mock_uuid)
      }.to raise_exception(Zendesk2::Error, /Description: cannot be blank/)
    end
  end

  describe "when creating a ticket" do
    let!(:requester_email) { "#{mock_uuid}@example.org" }

    it "should create requester" do
      ticket = client.tickets.create!(subject: mock_uuid, description: mock_uuid, requester: {name: "Josh Lane", email: requester_email})
      if Zendesk2::Client.mocking? # this takes some time for realsies
        requester = client.users.search(email: requester_email).first
        expect(requester).not_to be_nil

        expect(ticket.reload.requester).to eq(requester)
      else
        expect(ticket.reload.requester).not_to be_nil
      end
    end

    it "should require requester name" do
      expect {
        client.tickets.create!(subject: mock_uuid, description: mock_uuid, requester: {email: requester_email})
      }.to raise_exception(Zendesk2::Error, /Requester Name: .* too short/)
    end

    it "should require a description" do
      expect {
        client.tickets.create!(subject: mock_uuid)
      }.to raise_exception(ArgumentError, /description is required/)

      expect {
        client.tickets.create!(subject: mock_uuid, description: "")
      }.to raise_exception(ArgumentError, /description is required/)
    end

    it "should set priority" do
      priority = "urgent"

      ticket = client.tickets.create!(subject: mock_uuid, description: mock_uuid, priority: priority)

      expect(ticket.priority).to eq("urgent")
      expect(client.tickets.get!(ticket.id).priority).to eq(priority)
    end
  end

  describe "with a created ticket" do
    let(:ticket) { client.tickets.create!(subject: mock_uuid, description: mock_uuid) }

    it "should get requester" do
      expect(ticket.requester).to eq(client.users.current)
    end

    it "should get submitter" do
      expect(ticket.submitter).to eq(client.users.current)
    end

    it "should have empty custom fields by default", mock_only: true do
      expect(ticket.custom_fields).to eq([])
    end
  end

  describe "ticket comments" do
    let(:ticket) { client.tickets.create!(subject: mock_uuid, description: mock_uuid) }

    it "lists audits" do
      body = mock_uuid
      ticket.comment(body)

      audit = ticket.audits.last
      expect(audit.ticket).to eq(ticket)

      events = audit.events

      if Zendesk2::Client.mocking?
        expect(events.size).to eq(1)
      end

      event = events.first
      expect(event.body).to eq(body)
      expect(event).to be_a(Zendesk2::Client::TicketComment)
      expect(event.ticket_audit).to eq(audit)
    end

    it "lists comments" do
      body = mock_uuid
      ticket.comment(body)

      expect(ticket.comments.find{|c| c.body == body}).not_to be_nil
    end
  end

  describe "ticket custom fields" do
    let!(:ticket_field) { client.ticket_fields.create!(title: SecureRandom.hex(3), type: "text") }

    it "should be based on ticket_fields" do
      ticket = client.tickets.create!(subject: mock_uuid, description: mock_uuid)
      custom_field = ticket.custom_fields.find { |cf| cf["id"] == ticket_field.identity.to_s }

      expect(custom_field).not_to be_nil
      expect(custom_field["value"]).to be_nil

      ticket = client.tickets.create!(subject: mock_uuid, description: mock_uuid, custom_fields: [{"id" => ticket_field.identity, "value" => "jessicaspacekat"}])
      custom_field = ticket.custom_fields.find { |cf| cf["id"] == ticket_field.identity.to_s }

      expect(custom_field).not_to be_nil
      expect(custom_field["value"]).to eq("jessicaspacekat")

      ticket = client.tickets.create!(subject: mock_uuid, description: mock_uuid, custom_fields: [{"id" => "-1", "value" => "fantasy"}])
      expect(ticket.custom_fields).not_to include({"id" => -1, "value" => "fantasy"})
    end
  end
end
