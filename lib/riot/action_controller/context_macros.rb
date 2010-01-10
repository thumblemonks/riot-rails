module RiotRails #:nodoc:
  module ActionController #:nodoc:

    module ContextMacros
      # Sets up a context (and possibly child contexts) for testing a controller. Right now, it just takes a
      # symbol. Should change to allow you to pass in the class directly. You should put this at or near the
      # top of your context definition.
      #
      #   context "the FooBarsController" do
      #     controlling :foo_bars
      #     setup { get :index }
      #   end
      def controlling(controller_name)
        controller_class = constantize_controller_name(controller_name)
        setup do
          controller_class.instance_eval { include ::ActionController::TestCase::RaiseActionExceptions }
          @request = ::ActionController::TestRequest.new
          @response = ::ActionController::TestResponse.new
          @controller = controller_class.new
          @controller.params = {}
          @controller.request = @request
        end
      end

      # Creates a shortcut assertion that is to be used with the assertion macros for ActionController.
      #
      #   context "the FoosController" do
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
    private
      def constantize_controller_name(name)
        name.kind_of?(Class) ? name : "#{name.to_s.camelize}Controller".constantize
      end
    end # ContextMacros

  end # ActionController
end # RiotRails
