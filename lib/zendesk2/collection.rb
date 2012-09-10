class Zendesk2::Collection < Cistern::Collection
  def create!(attributes={})
    model = self.new(attributes)
    model.save!
  end
end
