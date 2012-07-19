shared_examples "a resource" do |_collection, _params, _update_params|
  let(:collection) { client.send(_collection) }
  let(:params) { instance_exec(&_params) || {} }
  let(:update_params) { instance_exec(&_update_params) }

  it "by creating a record" do
    record = collection.create(params)
    record.identity.should_not be_nil
  end

  context "that is paged" do
    before(:each) do
      2.times.each { collection.create(instance_exec(&_params)) }
    end

    it "by retrieving the first page" do
      collection.all("per_page" => "1").size.should == 1
    end

    it "by retrieving the next page" do
      first_page = collection.all("per_page" => 1)
      second_page = collection.all("per_page" => 1).next_page
      second_page.should_not == first_page
    end

    it "by retrieving the previous page" do
      first_page = collection.all("per_page" => "1")
      previous_to_second_page = collection.all("per_page" => 1).next_page.previous_page
      previous_to_second_page.should == first_page
    end
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
    record.should be_destroyed
  end

  it "should search" do
    record = collection.create(params)
    collection.search(params).should include(record)
  end
end
