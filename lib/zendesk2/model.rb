module Zendesk2::Model
  include Cistern::Model

  attr_accessor :errors

  # @abstract override in subclass
  # @raise [Zendesk2::Error] if unsuccessful
  def save!
    raise NotImplementedError
  end

  # calls {#save!} and sets {#errors} if unsuccessful and applicable
  # @return [Zendesk2::Model] self, regardless of success
  def save
    save!
  rescue Zendesk2::Error => exception
    self.errors = exception.response[:body]["details"].inject({}){|r,(k,v)| r.merge(k => v.map{|e| e["type"] || e["description"]})} rescue nil
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

  # re-define Cistern::Attributes#missing_attributes to require non-blank
  def missing_attributes(args)
    missing, required = super(args)
    blank, still_required = required.partition { |_,v| "" == v }
    missing.merge!(Hash[blank])

    [missing, Hash[still_required]]
  end

  def update!(attributes)
    merge_attributes(attributes)
    save!
  end
end
