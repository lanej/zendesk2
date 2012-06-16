shared_examples "a resource" do |_collection, _params, _update_params|
  let(:collection) { client.send(_collection) }
  let(:params) { instance_exec(&_params) || {} }
  let(:update_params) { instance_exec(&_update_params) }

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
  it "by updating a record" do
    record = collection.create(params)
    record.merge_attributes(update_params)
    record.save
    update_params.each {|k,v| record.send(k).should == v}
  end
  it "by destroy a record" do
    record = collection.create(params)
    record.identity.should_not be_nil
    record.destroy
    collection.get(record.id).should be_nil
  end
end
