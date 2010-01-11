module RiotRails #:nodoc:
  module ActionController #:nodoc:

    module ContextMacros
      # Sets up a context (and possibly child contexts) for testing a controller. Right now, it just takes a
      # symbol. Should change to allow you to pass in the class directly.
      #
      #   rails_context "the FooBarsController" do
      #     controlling :foo_bars
      #     setup { get :index }
      #   end
      def controlling(controller_name)
        controller_class = constantize_controller_name(controller_name)
        premium_setup do
          controller_class.instance_eval { include ::ActionController::TestCase::RaiseActionExceptions }
          @request = ::ActionController::TestRequest.new
          @response = ::ActionController::TestResponse.new
          @controller = controller_class.new
          @controller.params = {}
          @controller.request = @request
          @controller
        end
      end

      # Creates a shortcut assertion that is to be used with the assertion macros for ActionController.
      #
      #   rails_context "the FoosController" do
      #     controlling :foos
      #     setup { get :index }
      #
      #     asserts_controller.response_status(:found)
      #     asserts_controller.redirected_to { new_foo_path }
      #   end
      #
      # Works the same as if you wrote the following assertions:
      #
      #   asserts("controller") { controller }.response_status(:found)
      #   asserts("controller") { controller }.redirected_to { new_foo_path }
      def asserts_controller
        asserts("controller") { controller }
      end

      # Creates a shortcut assertion that returns the value of an assigned variable from the controller
      #
      #   rails_context UsersController do
      #     setup { get :show, :id => 1 }
      #
      #     asserts_assigned(:user).kind_of(User)
      #   end
      def asserts_assigned(variable)
        asserts("value assigned to @#{variable}") do
          @controller.instance_variable_get("@#{variable}".to_sym)
        end
      end
    private
      def constantize_controller_name(name)
        name.kind_of?(Class) ? name : "#{name.to_s.camelize}Controller".constantize
      end
    end # ContextMacros

  end # ActionController
end # RiotRails
