ENV['RAILS_ENV'] = 'test'

require "active_record/railtie"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "active_resource/railtie"

module Rails
  def self.root; File.expand_path(File.join(File.dirname(__FILE__), "..")); end
end

module RiotRails
  class Application < Rails::Application; end
end

require File.join(Rails.root, "config", "routes.rb")

# Logging stuff

class NilIO
  def write(*args); end
  def close(*args); end
  def puts(*args); end
  def path; nil; end
  def fsync; 0; end
  def to_s; "hello"; end
  def sync; true; end
  def sync=(arg); arg; end
end

def shhh(&block)
  orig_out = $stdout
  $stdout = NilIO.new
  yield
  $stdout = orig_out
end

shhh do
  require 'sqlite3'
  ActiveRecord::Base.configurations = {"test" => { "adapter" => "sqlite3", "database" => ":memory:"}}
  ActiveRecord::Base.establish_connection("test")
  load(File.join(Rails.root, "db", "schema.rb"))
end

ActiveRecord::Base.logger = Logger.new(NilIO.new)
ActionController::Base.view_paths = [File.join(Rails.root, 'app', 'views')]
