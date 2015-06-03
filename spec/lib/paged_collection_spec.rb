require 'spec_helper'

describe Zendesk2::PagedCollection, :mock_only do
  let!(:client) { create_client }

  let!(:records) { 333.times.each_with_index.map { |_,i| client.organizations.create(name: "#{i%3}_#{mock_uuid}") } }

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

  context "#all_entries" do

    it "should chain search paging" do
      matching_records = records.select { |o| o.name.match(/\A2_/) }
      expect(matching_records).not_to be_empty

      found_records = client.organizations.search(name: "2_").all_entries

      expect(found_records.size).to eq(matching_records.size)
      expect(found_records).to match_array(matching_records)
    end
  end
end
