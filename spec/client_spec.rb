#encoding: utf-8
require 'spec_helper'

describe Zendesk2 do
  context "when mocking", mock_only: true do
    # this used to cause user creation conflicts
    it "allows the client to be intialized more than once" do
      Zendesk2.new(username: "steve@example.org", url: "http://example.org")
      Zendesk2.new(username: "steve@example.org", url: "http://example.org")
    end
  end
end
