# frozen_string_literal: true
module Zendesk2::Attributes
  def assoc_reader(name, options = {})
    assoc_key  = options[:key] || "#{name}_id"
    collection = options[:collection] || "#{name}s"
    define_method(name) do
      assoc_id = send(assoc_key)
      if assoc_id
        cistern.send(collection).get(assoc_id)
      else
        instance_variable_get("@#{name}")
      end
    end
  end

  def assoc_writer(name, options = {})
    assoc_key = options[:key] || "#{name}_id"
    define_method("#{name}=") do |assoc|
      if assoc.is_a?(Cistern::Model)
        send("#{assoc_key}=", assoc.identity)
      else
        instance_variable_set("@#{name}", assoc)
      end
    end
  end

  def assoc_accessor(name, options = {})
    assoc_reader(name, options)
    assoc_writer(name, options)
  end

  # TODO: collection
end
