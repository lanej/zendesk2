require 'spec_helper'

describe Zendesk2::PagedCollection, :mock_only do
  let!(:client) { create_client }

  let!(:records) { 333.times.map { client.organizations.create(name: mock_uuid) } }

  context "#each_page" do
    it "should enumerate pages" do
      found_records = []
      client.organizations.all.each_page { |page| page.each { |entry| found_records << entry } }

      expect(records).to match_array(found_records)
    end
  end

  context "#each_entry" do
    it "should enumerate entries" do
      found_records = []
      client.organizations.all.each_entry { |entry| found_records << entry }

      expect(records).to match_array(found_records)
    end

    it "should chain enumerables" do
      target = records.sample
      found = client.organizations.all.each_entry.find { |entry| entry.id == target.id }

      expect(target).to eq(found)
    end
  end
end
