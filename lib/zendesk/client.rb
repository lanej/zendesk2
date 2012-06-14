require 'cistern'

class Zendesk::Client < Cistern::Service

  model_path "zendesk/models"
  request_path "zendesk/requests"

  model :user
  collection :users
  request :create_user
  request :get_user
  request :update_user
  request :destroy_user


  class Real

    def initialize(options={})
    end

  end

  class Mock

    def initialize(options={})
    end

  end

end
