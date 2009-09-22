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

# Test refactorings
module ProtestRails
  module Context
    def asserts_passes_failures_errors(passes=0, failures=0, errors=0)
      should("pass #{passes} test(s)") { topic.passes }.equals(passes)
      should("fail #{failures} test(s)") { topic.failures }.equals(failures)
      should("error on #{errors} test(s)") { topic.errors }.equals(errors)
    end

    def setup_and_run_context(name, *passes_failures_errors)
      context name do
        setup do
          @test_report = Protest::NilReport.new
          @test_context = Protest::Context.new("test context", @test_report)
          yield(@test_context)
          @test_context.report
          @test_report
        end
        asserts_passes_failures_errors(*passes_failures_errors)
      end
    end
  end
end

Protest::Context.instance_eval { include ProtestRails::Context }
