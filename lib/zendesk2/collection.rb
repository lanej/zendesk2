# @abstract adds {#create!} method
class Zendesk2::Collection < Cistern::Collection

  # Attempt creation of resource and explode if unsuccessful
  # @raise [Zendesk2::Error] if creation was unsuccessful
  # @return [Cistern::Model]
  def create!(attributes={})
    model = self.new(attributes.merge(Zendesk2.stringify_keys(self.attributes)))
    model.save!
  end

  # Quietly attempt creation of resource. Check {#new_record?} and {#errors} for success
  # @see {#create!} to raise an exception on failure
  # @return [Cistern::Model]
  def create(attributes={})
    model = self.new(attributes.merge(Zendesk2.stringify_keys(self.attributes)))
    model.save
  end
end
