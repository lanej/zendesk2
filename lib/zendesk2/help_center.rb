module Zendesk2::HelpCenter; end

Dir[File.expand_path("../requests/*_help_center_*.rb",           __FILE__)].each { |f| require(f) }
Dir[File.expand_path("../{models,collections}/help_center/*.rb", __FILE__)].each { |f| require(f) }
