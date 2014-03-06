shared_examples "zendesk resource" do |options={}|
  context "as a resource" do
    let!(:collection)   { instance_exec(&options[:collection]) }
    let(:create_params) { instance_exec(&options[:create_params]) || {} }
    let(:update_params) { instance_exec(&options[:update_params]) }
    let(:fetch_params)  { options[:fetch_params] || lambda { |r| r.identity } }

    it "should be created" do
      record = collection.create!(create_params)
      record.identity.should_not be_nil
    end

    it "should be fetched" do
      record = collection.create!(create_params)
      collection.get!(fetch_params.call(record)).should == record
    end

    if options.fetch(:paged, true)
      context "paging" do
        before(:each) do
          3.times.each { collection.create!(instance_exec(&options[:create_params])) }
        end

        it "should retrieve first page" do
          collection.all("per_page" => "1").size.should == 1
        end

        it "should retrieve next page" do
          first_page = collection.all("per_page" => 1)
          second_page = collection.all("per_page" => 1).next_page
          second_page.should_not == first_page
        end

        it "should retreive previous page" do
          first_page = collection.all("per_page" => "1")
          previous_to_second_page = collection.all("per_page" => 1).next_page.previous_page
          previous_to_second_page.should == first_page
        end
      end
    else
      context "paging" do
        it "should not be present" do
          collection.class.attributes.should_not have_key(:next_page_link)
          collection.class.attributes.should_not have_key(:previous_page_link)
          collection.class.attributes.should have_key(:count)
        end
      end
    end

    if options.fetch(:update, true)
      it "should be updated" do
        record = collection.create!(create_params)
        record.merge_attributes(update_params)
        record.save
        update_params.each {|k,v| record.send(k).should == v}
      end
    end

    it "should be destroyed" do
      record = collection.create!(create_params)
      record.identity.should_not be_nil
      record.destroy

      if !options.fetch(:delayed_destroy, false) && !Zendesk2::Client.mocking?
        record.should be_destroyed
      end
    end

    if options.fetch(:search, true) && Zendesk2::Client.mocking?
      # Search index takes 2-3 minutes according to the docs
      it "should search" do
        record = collection.create!(create_params)
        collection.search(create_params).should include(record)
      end
    end
  end
end
