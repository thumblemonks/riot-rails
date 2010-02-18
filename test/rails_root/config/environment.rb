# ENV_PATH  = File.expand_path('../../config/environment',  __FILE__)
# BOOT_PATH = File.expand_path('../../config/boot',  __FILE__)
# APP_PATH  = File.expand_path('../../config/application',  __FILE__)
# ROOT_PATH = File.expand_path('../..',  __FILE__)

# require "rails"
# Rails.root = RAILS_ROOT

require "active_record/railtie"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "active_resource/railtie"

module RiotRails
  class Application < Rails::Application; end
end

# RiotRails::Application.initialize!

require File.join(ENV["RAILS_ROOT"], "config", "routes.rb")
