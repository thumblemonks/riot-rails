require 'protest/rails'
require 'activerecord'

RAILS_ROOT = File.dirname(__FILE__) + '/rails_root'

def shhh(&block)
  orig_out = $stdout
  $stdout = StringIO.new
  yield
  $stdout = orig_out
end

# Database setup
shhh do
  ActiveRecord::Base.configurations = {"test" => { "adapter" => "sqlite3", "database" => ":memory:"}}
  ActiveRecord::Base.establish_connection("test")
  load(File.join(RAILS_ROOT, "db", "schema.rb"))
end

# Model definition
class Room < ActiveRecord::Base
  validates_presence_of :location, :foo, :bar
  validates_format_of :email, :with => /^\w+@\w+\.\w+$/
end
