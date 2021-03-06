# frozen_string_literal: true
module Zendesk2::Collection
  class << self
    alias cistern_included included

    def included(receiver)
      cistern_included(receiver)
      receiver.extend(ClassMethods)
      super
    end
  end

  # Add interface methods for response constants
  module ClassMethods
    attr_accessor :collection_method, :collection_root, :model_method, :model_root

    attr_writer :namespace

    def namespace
      @namespace || model_root
    end

    def scopes
      @scopes ||= []
    end
  end

  def collection_method
    self.class.collection_method
  end

  def collection_root
    self.class.collection_root
  end

  def model_method
    self.class.model_method
  end

  def model_root
    self.class.model_root
  end

  def namespace
    self.class.namespace
  end

  # Attempt creation of resource and explode if unsuccessful
  # @raise [Zendesk2::Error] if creation was unsuccessful
  # @return [Cistern::Model]
  def create!(attributes = {})
    model = new(attributes.merge(Zendesk2.stringify_keys(self.attributes)))
    model.save!
  end

  # Quietly attempt creation of resource. Check {#new_record?} and {#errors} for success
  # @see {#create!} to raise an exception on failure
  # @return [Cistern::Model, FalseClass]
  def create(attributes = {})
    model = new(attributes.merge(Zendesk2.stringify_keys(self.attributes)))
    model.save
  end

  # Fetch a collection of resources
  def all(params = {})
    scoped_attributes = self.class.scopes.inject({}) { |a, e| a.merge(e.to_s => public_send(e)) }.merge(params)
    body = cistern.send(collection_method, scoped_attributes).body

    load(body[collection_root])
    merge_attributes(Cistern::Hash.slice(body, 'count'))
    self
  end

  # Fetch a single of resource
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
    scoped_attributes = self.class.scopes.inject({}) { |a, e| a.merge(e.to_s => public_send(e)) }

    if identity_or_hash.is_a?(Hash)
      scoped_attributes.merge!(identity_or_hash)
    else
      scoped_attributes['id'] = identity_or_hash
    end

    scoped_attributes = { namespace => scoped_attributes }
    data = cistern.send(model_method, scoped_attributes).body[model_root]
    new(data) if data
  end

  # Quiet version of {#get!}
  # @see #get!
  # @return [Zendesk2::Model] Fetched model when successful
  # @return [NilClass] return nothing if record cannot be found
  def get(*args)
    get!(*args)
  rescue Zendesk2::Error
    nil
  end

  def new(attributes = {})
    super(self.attributes.merge(attributes))
  end
end
