require 'spec_helper'

RSpec.describe Zendesk2::RateLimit do
  class Puppet
    def self.add_response(response)
      self.responses.unshift(response)
    end

    def self.responses
      @responses ||= []
    end

    def self.call(env)
      self.responses.shift || raise("not response set")
    end
  end

  it "should delay requests for the specified time" do
    client = Faraday.new do |connection|
      connection.use Zendesk2::RateLimit
      connection.adapter :rack, Puppet
    end

    Puppet.responses << [429, {"Retry-After" => 0.1}, []]
    Puppet.responses << [429, {"Retry-After" => 0.2}, []]
    Puppet.responses << [200, {}, ["something"]]

    response = client.get("/")

    expect(response.status).to eq(200)
    expect(response.headers[:rate_limits].to_s).to match(/^0\.3/) # ugh float math
  end
end
