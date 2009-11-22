require 'rubygems'
require 'active_record'
require 'action_controller'

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

#
# Setup faux Rails environment

RAILS_ROOT = File.join(File.dirname(__FILE__), 'rails_root')

require File.join(RAILS_ROOT, "config", "routes.rb")

shhh do
  ActiveRecord::Base.configurations = {"test" => { "adapter" => "sqlite3", "database" => ":memory:"}}
  ActiveRecord::Base.establish_connection("test")
  load(File.join(RAILS_ROOT, "db", "schema.rb"))
end

ActiveRecord::Base.logger = Logger.new(NilIO.new)
ActionController::Base.view_paths = [File.join(RAILS_ROOT, 'app', 'views')]

#
# Model definition

class Room < ActiveRecord::Base
  validates_presence_of :location, :foo, :bar
  validates_format_of :email, :with => /^\w+@\w+\.\w+$/
  validates_uniqueness_of :email

  has_many :doors
  has_one :floor

  def self.create_with_good_data(attributes={})
    create!({:location => "a", :foo => "b", :bar => "c", :email => "a@b.c"}.merge(attributes))
  end
end

#
# Test refactorings

require 'riot/rails'

module RiotRails
  module Context
    def asserts_passes_failures_errors(passes=0, failures=0, errors=0)
      should("pass #{passes} test(s)") { topic.passes }.equals(passes)
      should("fail #{failures} test(s)") { topic.failures }.equals(failures)
      should("error on #{errors} test(s)") { topic.errors }.equals(errors)
    end

    def setup_with_test_context(&block)
      setup do
        @test_report = Riot::SilentReporter.new
        @test_context = Riot::Context.new("test context", @test_report)
        yield(@test_context)
        @test_context.report
        @test_report
      end
    end

    def setup_and_run_context(name, *passes_failures_errors, &block)
      context name do
        setup_with_test_context(&block)
        asserts_passes_failures_errors(*passes_failures_errors)
      end
    end
  end
end

Riot::Context.instance_eval { include RiotRails::Context }

#
## Let's see if we can get this way working sometime in the future

# def get(action, options={})
#   @env = {}
#   @request = ActionController::TestRequest.new(@env)
#   # @request = Rack::MockRequest.new(@app)
#   # @response = @request.request("GET", path, options)
#   # request = ActionController::TestRequest.new(@env)
#   @request.query_parameters["action"] = action
#   @env["action_controller.rescue.request"] = @request
#   @env["action_controller.rescue.response"] = ActionController::TestResponse.new
#   @app.call(@env)
# end

# setup do
  # DashboardsController.instance_eval { include ActionController::TestCase::RaiseActionExceptions }
  # @controller_class = DashboardsController
  # @app = DashboardsController
# end
