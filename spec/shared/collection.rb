shared_examples "a collection" do |_collection, _params|
  let(:collection) { client.send(_collection) }
  let(:params) { instance_exec(&_params) || {} }
  it "by creating a record" do
    record = collection.create(params)
    record.identity.should_not be_nil
  end
  it "by listing records" do
    collection.create(params)
    collection.all("per_page" => "1").size.should == 1
  end
  it "by fetching a specific record" do
    record = collection.create(params)
    collection.get(record.identity).should == record
  end
end
