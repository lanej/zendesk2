# frozen_string_literal: true
class Zendesk2::GetTicketForms
  include Zendesk2::Request

  request_method :get
  request_path { |_| '/ticket_forms.json' }
  request_params do |r|
    result = {}
    result['active'] = r.active unless r.active.nil?
    result['end_user_visible'] = r.end_user_visible unless r.end_user_visible.nil?
    result['fallback_to_default'] = r.fallback_to_default unless r.fallback_to_default.nil?
    result['associated_to_brand'] = r.associated_to_brand unless r.associated_to_brand.nil?
    result
  end

  page_params!

  def active
    params['active']
  end

  def end_user_visible
    params['end_user_visible']
  end

  def fallback_to_default
    params['fallback_to_default']
  end

  def associated_to_brand
    params['associated_to_brand']
  end

  def mock
    page(:ticket_forms)
  end
end
