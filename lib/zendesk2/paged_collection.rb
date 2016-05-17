# adds {#create!} method to {Cistern::Collection}.
module Zendesk2::PagedCollection
  def self.included(klass)
    klass.send(:attribute, :count)
    klass.send(:attribute, :next_page_link, {:aliases => "next_page"})
    klass.send(:attribute, :previous_page_link, {:aliases => "previous_page"})
    klass.send(:extend, ClassMethods)
  end

  def collection_method; self.class.collection_method; end
  def collection_root; self.class.collection_root; end
  def model_method; self.class.model_method; end
  def model_root; self.class.model_root; end

  def new_page
    page = self.class.new(service: self.service)
    page.merge_attributes(self.class.scopes.inject({}){|r,k| r.merge(k.to_s => send(k))})
    page
  end

  def each_page
    return to_enum(:each_page) unless block_given?
    page = self
    while page
      yield page
      page = page.next_page
    end
  end

  def each_entry
    return to_enum(:each_entry) unless block_given?
    page = self
    while page
      page.to_a.each { |r| yield r }
      page = page.next_page
    end
  end

  def all_entries
    each_entry.to_a
  end

  def next_page
    if next_page_link
      options = {"url" => next_page_link}
      if self.respond_to?(:filtered) # searchable
        options.merge!("filtered" => self.filtered)
      end
      new_page.all(options)
    end
  end

  def previous_page
    if previous_page_link
      options = {"url" => previous_page_link}
      if self.respond_to?(:filtered) # searchable
        options.merge!("filtered" => self.filtered)
      end
      new_page.all(options)
    end
  end

  # Attempt creation of resource and explode if unsuccessful
  #
  # @raise [Zendesk2::Error] if creation was unsuccessful
  # @return [Zendesk::Model]
  def create!(attributes={})
    model = self.new(Zendesk2.stringify_keys(attributes).merge(Zendesk2.stringify_keys(self.attributes)))
    model.save!
  end

  # Quietly attempt creation of resource. Check {#new_record?} and {#errors} for success
  #
  # @see {#create!} to raise an exception on failure
  # @return [Zendesk::Model, FalseClass]
  def create(attributes={})
    model = self.new(attributes.merge(Zendesk2.stringify_keys(self.attributes)))
    model.save
  end

  # Iterate over all pages and collect every entry
  #
  # @return [Array<Zendesk2::Model>] all entries in all pages
  def all_entries
    each_entry.to_a
  end

  # Fetch a collection of resources
  def all(params={})
    if search_query?(params)
      search_page(params)
    else
      collection_page(params)
    end
    self
  end

  # Fetch a single of resource
  #
  # @overload get!(identity)
  #   fetch a un-namespaced specific record or a namespaced record under the current {#scopes}
  #   @param [Integer] identity identity of the record
  # @overload get!(scope)
  #   directly fetch a namespaced record
  #   @param [Hash] scope parameters to fetch record
  # @example Fetch a record without contextual scoping
  #   self.identities.all("user_id" => 2, "id" => 4) # context defined directly
  # @example Fetch a record with contextual scoping
  #   self.identities("user_id" => 2).get(4) # context defined in collection
  #   user.identities.get(4)                 # context defined by encapsulating model
  # @raise [Zendesk2::Error] if the record cannot be found or other request error
  # @return [Zendesk2::Model] fetched resource corresponding to value of {Zendesk2::Collection#model}
  def get!(identity_or_hash)
    scoped_attributes = self.class.scopes.inject({}){|r,k| r.merge(k.to_s => send(k))}

    if identity_or_hash.is_a?(Hash)
      scoped_attributes.merge!(identity_or_hash)
    else
      scoped_attributes.merge!("id" => identity_or_hash)
    end

    scoped_attributes = { model_root => scoped_attributes }

    if data = self.service.send(model_method, scoped_attributes).body[self.model_root]
      new(data)
    end
  end

  # Quiet version of {#get!}
  #
  # @see #get!
  # @return [Zendesk2::Model] Fetched model when successful
  # @return [NilClass] return nothing if record cannot be found
  def get(*args)
    get!(*args)
  rescue Zendesk2::Error
    nil
  end

  module ClassMethods
    attr_accessor :collection_method, :collection_root, :model_method, :model_root

    def scopes
      @scopes ||= []
    end
  end

  protected

  def search_query?(params)
    !!params["filtered"] && !!params["url"]
  end

  def search_page(params)
    query = Faraday::NestedParamsEncoder.decode(URI.parse(params.fetch("url")).query)

    search(query.delete("query"), query)
  end

  def collection_page(params)
    scoped_attributes = self.class.scopes.inject({}) { |r, k| r.merge(k.to_s => send(k)) }.merge(params)
    body = service.send(collection_method, scoped_attributes).body

    self.load(body[collection_root]) # 'results' is the key for paged seraches
    self.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
  end
end
