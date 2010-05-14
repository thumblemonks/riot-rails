$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'rubygems'
require 'pathname'

#
# Setup faux Rails environment

require(Pathname(__FILE__).dirname + 'rails_root' + 'config' + 'environment')

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
# Blah == anything, whatever. Always passes an equality test

class Blah
  def ==(o) true; end
  def inspect; "<blah>"; end
  alias :to_s :inspect
end

class Object
  def blah; Blah.new; end
end

#
# Riot setup

require 'riot/rails'
require 'riot/active_record'
require 'riot/action_controller'

Riot.dots if ENV["TM_MODE"]

module RiotRails
  module Context
    def setup_test_context(context_description="test context")
      setup { Riot::Context.new(context_description) {} }
    end

    def setup_for_assertion_test(&block)
      hookup { topic.setup(&block).run(@situation) }
    end

    def hookup_for_assertion_test(&block)
      hookup { topic.hookup(&block).run(@situation) }
    end

    def assertion_test_passes(description, success_message="", &block)
      should("pass #{description}") do
        instance_eval(&block).run(@situation)
      end.equals([:pass, success_message])
    end

    def assertion_test_fails(description, failure_message, &block)
      should("fail #{description}") do
        instance_eval(&block).run(@situation)
      end.equals([:fail, failure_message, blah, blah])
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
