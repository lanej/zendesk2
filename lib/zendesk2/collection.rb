# @abstract adds {#create!} method
class Zendesk2::Collection < Cistern::Collection

  # Attempt creation of resource and explode if unsuccessful
  # @raise [Zendesk2::Error] if creation was unsuccessful
  # @return [Cistern::Model] created model
  def create!(attributes={})
    model = self.new(attributes)
    model.save!
  end
end
