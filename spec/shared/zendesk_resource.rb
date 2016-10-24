# frozen_string_literal: true
shared_examples 'zendesk#resource' do |options = {}|
  context 'as a resource' do
    let!(:collection)   { instance_exec(&options[:collection]) }
    let(:create_params) { instance_exec(&options[:create_params]) || {} }
    let(:update_params) { instance_exec(&options[:update_params]) }
    let(:fetch_params)  { options[:fetch_params] || ->(r) { r.identity } }
    let(:search_params) { options[:search_params] ? instance_exec(&options[:search_params]) : create_params }

    let(:record) { @record }
    after(:each) { @record && @record.destroy }

    it 'should be created' do
      @record = collection.create!(create_params)
      expect(record.identity).not_to be_nil
    end

    it 'should be fetched' do
      @record = collection.create!(create_params)
      expect(collection.get!(fetch_params.call(record))).to eq(record)
    end

    if options.fetch(:paged, true)
      context 'paging' do
        before(:each) do
          if collection.reload.count < 3
            @resources = Array.new(3) { collection.create!(instance_exec(&options[:create_params])) }
          end
        end

        after(:each) { (@resources || []).each(&:destroy) }

        it 'should retrieve first page' do
          expect(collection.all('per_page' => '1').size).to eq(1)
        end

        it 'should retrieve next page' do
          first_page = collection.all('per_page' => 1)
          second_page = collection.all('per_page' => 1).next_page
          expect(second_page).not_to eq(first_page)
        end

        it 'should retreive previous page' do
          first_page = collection.all('per_page' => '1')
          previous_to_second_page = collection.all('per_page' => 1).next_page.previous_page
          expect(previous_to_second_page).to eq(first_page)
        end
      end
    else
      context 'paging' do
        it 'should not be present' do
          expect(collection.class.attributes).not_to have_key(:next_page_link)
          expect(collection.class.attributes).not_to have_key(:previous_page_link)
          expect(collection.class.attributes).to have_key(:count)
        end
      end
    end

    context 'index' do
      let!(:resource) { @resource = collection.create!(instance_exec(&options[:create_params])) }

      after { @resource.destroy if @resource }

      # real index actions sometimes have delays in population
      it 'lists', mock_only: true do
        expect(collection.all).to include(resource)
      end
    end

    if options.fetch(:update, true)
      it 'should be updated' do
        @record = collection.create!(create_params)
        update_params.each { |k, v| record.send("#{k}=", v) }
        record.save
        update_params.each do |k, to|
          from = record.send(k)
          expect(from).to eq(to), "Expected #{k} to be updated #{from.inspect} to #{to.inspect}"
        end
      end
    end

    if options.fetch(:destroy, true)
      it 'should be destroyed' do
        @record = collection.create!(create_params)
        expect(record.identity).not_to be_nil
        record.destroy

        if !options.fetch(:delayed_destroy, false) && !Zendesk2.mocking?
          expect(record).to be_destroyed
        end
      end
    end

    if options.fetch(:search, true) && Zendesk2.mocking?
      # Search index takes 2-3 minutes according to the docs
      it 'should search by hash' do
        @record = collection.create!(create_params)
        expect(collection.search(search_params).to_a).to eq([record])
      end

      it 'should search by string' do
        @record = collection.create!(create_params)
        expect(collection.search(search_params.map { |k, v| [k, v].join(':') }.join(' ')).to_a).to eq([record])
      end
    end
  end
end
