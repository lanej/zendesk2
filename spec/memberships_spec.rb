require 'spec_helper'

describe "memberships" do
  let!(:client)      { create_client }
  let!(:user)        { client.users.create!(email: mock_email, name: mock_uuid, verified: true) }
  let(:organization) { client.organizations.create!(name: mock_uuid) }

  include_examples "zendesk#resource", {
    :create_params => lambda { { organization_id: client.organizations.create!(name: mock_uuid).identity, user_id: user.id } },
    :collection    => lambda { client.memberships(user: user) },
    :paged         => true,
    :update        => false,
    :search        => false,
  }

  it "should be marked as default" do
    membership           = client.memberships.create!(organization: organization, user: user).reload
    another_organization = client.organizations.create!(name: mock_uuid)

    another_membership = client.memberships.create!(organization: another_organization, user: user).reload

    expect(membership.default).to eq(true)
    expect(another_membership.default).to eq(false)

    expect {
      another_membership.default!
    }.to change {
      another_membership.reload.default
    }.from(false).to(true)

    expect(membership.reload.default).to be_falsey
  end

  it "should get an organization's memberships" do
    another_user         = client.users.create!(email: mock_email, name: mock_uuid, verified: true)
    another_organization = client.organizations.create!(name: mock_uuid)

    another_organization.memberships.create!(user: another_user)
    another_organization.memberships.create!(user: user)
    organization.memberships.create!(user: another_user)

    expect(organization.memberships.size).to eq(1)
    expect(another_organization.memberships.size).to eq(2)
  end

  it "should get an user's memberships" do
    another_user = client.users.create!(email: mock_email, name: mock_uuid, verified: true)
    another_organization = client.organizations.create!(name: mock_uuid)

    another_organization.memberships.create!(user: another_user)
    user_membership = another_organization.memberships.create!(user: user)
    organization.memberships.create!(user: another_user)

    expect(user.memberships.to_a).to eq([user_membership])
    expect(another_user.memberships.size).to eq(2)
  end

  it "should get a user's organizations" do
    another_user = client.users.create!(email: mock_email, name: mock_uuid, verified: true)
    another_organization = client.organizations.create!(name: mock_uuid)

    another_organization.memberships.create!(user: another_user)
    another_organization.memberships.create!(user: user)
    organization.memberships.create!(user: another_user)

    expect(user.organizations.to_a).to contain_exactly(another_organization)
    expect(another_organization.users.to_a).to contain_exactly(user, another_user)
    expect(organization.users.to_a).to contain_exactly(another_user)
  end

  describe "create_membership" do
    it "should error when organization does not exist" do
      expect {
        client.create_membership("membership" => { "user_id" => user.identity, "organization_id" => 99 })
      }.to raise_exception(Zendesk2::Error, /RecordInvalid/)
    end

    it "should error when creating a duplicate membership" do
      client.create_membership("membership" => { "user_id" => user.identity, "organization_id" => organization.identity })

      expect {
        client.create_membership("membership" => { "user_id" => user.identity, "organization_id" => organization.identity })
      }.to raise_exception(Zendesk2::Error, /RecordInvalid/)
    end

    it "should error when user does not exist" do
      expect {
        client.create_membership("membership" => { "user_id" => 99, "organization_id" => organization.identity })
      }.to raise_exception(Zendesk2::Error, /RecordNotFound/)
    end
  end
end
