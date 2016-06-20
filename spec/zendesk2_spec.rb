# frozen_string_literal: true
require 'spec_helper'

describe 'Zendesk2::Client', 'messages' do
  around do |example|
    current = Cistern.deprecation_warnings?
    Cistern.deprecation_warnings = true
    example.run
    Cistern.deprecation_warnings = current
  end

  specify('are deprecated') do
    expect { Zendesk2::Client.mocking? }.to output(/deprecated, use Zendesk2/).to_stderr_from_any_process
  end
end
