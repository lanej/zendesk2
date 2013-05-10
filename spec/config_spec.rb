require 'spec_helper'

describe "client" do

  it "can be configured" do
    client = Zendesk2::Client.new(:url => "https://myzen.zendesk.com",
                                  :username => "person@place.com",
                                  :password => "wickedsecure",
                                  :token => "12345678901234567890",
                                  :jwt_token => "234823472398472938423234")
    client.url.should eq "https://myzen.zendesk.com"
    client.username.should eq "person@place.com"
    client.token.should eq "12345678901234567890"
    client.jwt_token.should eq "234823472398472938423234"
  end

end
