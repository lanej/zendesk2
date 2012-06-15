shared_examples "a collection" do |_collection, _params|
  let(:collection) { client.send(_collection) }
  let(:params) { _params || {} }
  it "by creating a record" do
    record = collection.create(params)
    record.identity.should_not be_nil
  end
  it "by listing records" do
    record = collection.create(params)
    collection.all.should include record
  end
  it "by fetching a specific record" do
    record = collection.create(params)
    collection.get(record.identiy).should == record
  end
end
