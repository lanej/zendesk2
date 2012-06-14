shared_examples "a collection" do |collection, params|
  it "by creating a record" do
    record = client.send(:collection).create(params)
    record.identity.should_not be_nil
  end
  it "by listing records" do
    record = client.send(:collection).create(params)
    client.send(:collection).all.should include record
  end
  it "by fetching a specific record" do
    record = client.send(:collection).create(params)
    client.send(:collection).get(record.identiy).should == record
  end
end
