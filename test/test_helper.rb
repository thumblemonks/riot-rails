require 'protest/rails'

require 'activerecord'

RAILS_ROOT = File.dirname(__FILE__) + '/rails_root'

# Database setup
ActiveRecord::Base.configurations = {"test" => { "adapter" => "sqlite3", "database" => ":memory:"}}
ActiveRecord::Base.establish_connection("test")
load(File.join(RAILS_ROOT, "db", "schema.rb"))
