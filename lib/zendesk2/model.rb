# @abstract subclass and implement {#save!} and {#destroy!}
class Zendesk2::Model < Cistern::Model
  attr_accessor :errors

  # @abstract override in subclass
  # @raise [Zendesk2::Error] if unsuccessful
  def save!
    raise NotImplementError
  end

  # calls {#save!} and sets {#errors} if unsuccessful and applicable
  # @return [Zendesk2::Model] self, regardless of success
  def save
    save!
  rescue Zendesk2::Error => e
    self.errors = e.response[:body]["details"].inject({}){|r,(k,v)| r.merge(k => v.map{|e| e["type"] || e["description"]})} rescue nil
    self
  end

  def destroyed?
    !self.reload
  end

  def destroy
    destroy!
  rescue Zendesk2::Error
    false
  end
end
