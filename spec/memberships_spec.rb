require 'spec_helper'

describe "memberships" do
  let(:client) { create_client }
  let(:user)   { client.users.create!(email: "zendesk2+#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, verified: true) }
  let(:organization)   { client.organizations.create!(name: Zendesk2.uuid) }

  include_examples "zendesk resource", {
    :params       => lambda { {organization_id: organization.id, user_id: user.id} },
    :collection   => lambda { client.memberships(user: user) },
    :paged        => false,
    :update       => false,
    :search       => false,
  }

  it "should be marked as default" do
    membership           = client.memberships.create!(organization: organization, user: user)
    another_organization = client.organizations.create!(name: Zendesk2.uuid)

    another_membership = client.memberships.create!(organization: another_organization, user: user)

    membership.default.should be_false # for some reason
    another_membership.default.should be_false

    expect { another_membership.default! }.to change { another_membership.reload.default }.from(false).to(true)

    membership.reload.default.should be_false
  end

  it "should get an organization's memberships" do
    another_user = client.users.create!(email: "zendesk2+#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, verified: true)
    another_organization = client.organizations.create!(name: Zendesk2.uuid)

    another_organization.memberships.create!(user: another_user)
    another_organization.memberships.create!(user: user)
    organization.memberships.create!(user: another_user)

    organization.memberships.size.should == 1
    another_organization.memberships.size.should == 2
  end

  it "should get an user's memberships" do
    another_user = client.users.create!(email: "zendesk2+#{Zendesk2.uuid}@example.org", name: Zendesk2.uuid, verified: true)
    another_organization = client.organizations.create!(name: Zendesk2.uuid)

    another_organization.memberships.create!(user: another_user)
    user_membership = another_organization.memberships.create!(user: user)
    organization.memberships.create!(user: another_user)

    user.memberships.to_a.should == [user_membership]
    another_user.memberships.size.should == 2
  end

  describe "create_membership" do
    it "should error when organization does not exist" do
      expect {
        client.create_membership("user_id" => user.identity, "organization_id" => 99)
      }.to raise_exception(Zendesk2::Error, /RecordInvalid/)
    end

    it "should error when missing parameters" do
      expect { client.create_membership({}) }.to raise_exception(ArgumentError, "missing parameters: user_id, organization_id")
    end

    it "should error when user does not exist" do
      expect {
        client.create_membership("user_id" => 99, "organization_id" => organization.identity)
      }.to raise_exception(Zendesk2::Error, /RecordNotFound/)
    end
  end
end
