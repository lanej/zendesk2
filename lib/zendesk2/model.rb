class Zendesk2::Model < Cistern::Model

  attr_accessor :errors

  def save
    save!
  rescue Zendesk2::Error => e
    self.errors= e.response[:body]["details"].inject({}){|r,(k,v)| r.merge(k => v.map{|e| e["type"] || e["description"]})} rescue nil
    self
  end
end
