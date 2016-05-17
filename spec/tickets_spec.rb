require 'spec_helper'

describe "Zendesk2" do
  let(:client) { create_client }

  describe "tickets" do
    include_examples "zendesk#resource", {
      :collection    => lambda { client.tickets },
      :create_params => lambda { {subject: mock_uuid, description: mock_uuid} },
      :update_params => lambda { {subject: mock_uuid} },
    }
  end

  describe "#create_ticket" do
    it "should require a description" do
      expect {
        client.create_ticket("ticket" => {"subject" => mock_uuid})
      }.to raise_exception(Zendesk2::Error, /Description: cannot be blank/)
    end
  end

  describe "when creating a ticket" do
    it "should create requester" do
      requester_email = mock_email

      ticket = client.tickets.create!(subject: mock_uuid, description: mock_uuid, requester: {name: "Josh Lane", email: requester_email})

      if Zendesk2.mocking? # this takes some time for realsies
        requester = client.users.search(email: requester_email).first
        expect(requester).not_to be_nil

        expect(ticket.reload.requester).to eq(requester)
      else
        expect(ticket.reload.requester).not_to be_nil
      end
    end

    context 'valid requester exists' do
      it 'sets organization id' do
        ticket = client.tickets.create!(subject: mock_uuid, description: mock_uuid, requester_id: 11111111111199)

        expect(ticket.organization_id).to be_nil
      end
    end

    it "should default to the requesters primary organization if organization is not specified" do
      organization = client.organizations.create!(name: mock_uuid)
      requester = client.users.create!(email: mock_email, name: mock_uuid, organization: organization)

      ticket = client.tickets.create!(requester: requester, subject: mock_uuid, description: mock_uuid)

      expect(ticket.organization).to eq(organization)
      expect(organization.tickets).to contain_exactly(ticket)
    end

    it "should require requester name" do
      expect {
        client.tickets.create!(subject: mock_uuid, description: mock_uuid, requester: {email: mock_email})
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

  describe "ticket#comments" do
    let!(:ticket)         { client.tickets.create!(subject: mock_uuid, description: mock_uuid) }
    let!(:another_ticket) { client.tickets.create!(subject: mock_uuid, description: mock_uuid)  }

    it "should scope the comments to the source ticket" do
      target_comments = 2.times.map { ticket.comment(mock_uuid) }
      2.times.map { another_ticket.comment(mock_uuid) }

      expect(ticket.comments.all).to include(*target_comments) # @fixme model (subject + description) || (comment) on create_ticket as a comment
    end
  end

  describe "ticket comments" do
    let(:ticket) { client.tickets.create!(subject: mock_uuid, description: mock_uuid) }

    it "lists audits" do
      body = mock_uuid
      comment = ticket.comment(body)
      expect(comment.body).to eq(body)

      audit = ticket.audits.last
      expect(audit.ticket).to eq(ticket)

      events = audit.events

      if Zendesk2.mocking?
        expect(events.size).to eq(1)
      end

      event = events.first
      expect(event.body).to eq(body)
      expect(event).to be_a(Zendesk2::TicketComment)
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
      custom_field = ticket.custom_fields.find { |cf| cf["id"].to_s == ticket_field.identity.to_s }

      expect(custom_field).not_to be_nil
      expect(custom_field["value"]).to be_nil

      ticket = client.tickets.create!(subject: mock_uuid, description: mock_uuid, custom_fields: [{"id" => ticket_field.identity, "value" => "jessicaspacekat"}])
      custom_field = ticket.custom_fields.find { |cf| cf["id"] == ticket_field.identity }

      expect(custom_field).to be
      expect(custom_field["value"]).to eq("jessicaspacekat")

      ticket = client.tickets.create!(subject: mock_uuid, description: mock_uuid, custom_fields: [{"id" => "-1", "value" => "fantasy"}])
      expect(ticket.custom_fields).not_to include({"id" => -1, "value" => "fantasy"})
    end
  end
end
