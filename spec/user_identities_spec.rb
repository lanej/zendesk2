require 'spec_helper'

describe "user_identities" do
  let(:client) { create_client }
  let(:user)   { client.users.create(email: "zendesk2+#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, verified: true) }

  include_examples "zendesk resource", {
    :create_params => lambda { { value: "ey+#{Zendesk2.uuid}@example.org", type: "email", user_id: user.id } },
    :update_params => lambda { { verified: true } },
    :fetch_params  => lambda { |uc| { "user_id" => uc.user_id, "id" => uc.id } },
    :collection    => lambda { client.user_identities(user_id: user.id) },
    :paged         => false,
    :search        => false,
  }

  describe "#create_user_identity" do
    let(:another_user) { client.users.create(email: "zendesk2+#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, verified: true) }

    it "should prevent duplicate identities across users" do
      expect {
        client.create_user_identity("type" => "email", "value" => user.email, "user_id" => another_user.id)
      }.to raise_exception(Zendesk2::Error, /is already being used by another user/)
    end

    it "should prevent duplicate identities on the same user" do
      expect {
        client.create_user_identity("type" => "email", "value" => user.email, "user_id" => user.id)
      }.to raise_exception(Zendesk2::Error, /is already being used by another user/)
    end
  end
end
