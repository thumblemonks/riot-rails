$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

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
  validates_presence_of :location
  validates_format_of :email, :with => /^\w+@\w+\.\w+$/
  validates_uniqueness_of :email
  validates_length_of :name, :within => 5..20
  validates_length_of :contents, :within => 0..100, :allow_blank => true

  has_many :doors, :class_name => 'Porthole'
  has_one :floor, :class_name => "Substrate"
  has_and_belongs_to_many :walls, :join_table => "floorplans"
  belongs_to :house
  belongs_to :owner, :class_name => 'SomethingElse'

  def self.create_with_good_data(attributes={})
    create!({:location => "a", :email => "a@b.c", :name => "Junior"}.merge(attributes))
  end
end

#
# Test refactorings

require 'riot/rails'

module RiotRails
  module Context
    def setup_test_context(context_description="test context")
      setup { Riot::Context.new(context_description) {} }
    end

    def setup_for_assertion_test(&block)
      setup do
        topic.setup(&block).run(@situation)
        topic
      end
    end

    def assertion_test_passes(description, success_message=nil, &block)
      should("pass #{description}") do
        instance_eval(&block).run(@situation)
      end.equals([:pass, success_message])
    end

    def assertion_test_fails(description, failure_message, &block)
      should("fail #{description}") do
        instance_eval(&block).run(@situation)
      end.equals([:fail, failure_message])
    end

  end # Context
end # RiotRails

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
