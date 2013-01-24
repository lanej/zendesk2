module Zendesk2::Attributes
  def assoc_reader(name, options={})
    assoc_key  = options[:key] || "#{name}_id"
    collection = options[:collection] || "#{name}s"
    define_method(name) do
      requires assoc_key

      self.connection.send(collection).get(self.send(assoc_key))
    end
  end

  def assoc_writer(name, options={})
    assoc_key = options[:key] || "#{name}_id"
    define_method("#{name}=") do |assoc|
      self.send("#{assoc_key}=", assoc.id)
    end
  end

  def assoc_accessor(name, options={})
    assoc_reader(name, options)
    assoc_writer(name, options)
  end

  # TODO: collection
end
