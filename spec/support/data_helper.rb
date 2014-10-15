module DataHelper
  def mock_email
    "zendesk2+#{mock_uuid}@example.org"
  end

  def mock_uuid
    SecureRandom.uuid
  end
end

RSpec.configure do |config|
  config.include(DataHelper)
end
