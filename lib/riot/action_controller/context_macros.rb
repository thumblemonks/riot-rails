module Riot
  module ActionController

    module ContextMacros
      def controlling(controller_name)
        controller_class = "#{controller_name.to_s.camelize}Controller".constantize
        setup do
          controller_class.instance_eval { include ::ActionController::TestCase::RaiseActionExceptions }
          @request = ::ActionController::TestRequest.new
          @response = ::ActionController::TestResponse.new
          @controller = controller_class.new
          @controller.params = {}
          @controller.request = @request
        end
      end

      def controller
        asserts("controller") { @controller }
      end
    end # ContextMacros

  end # ActionController
end # Riot

Riot::Context.instance_eval { include Riot::ActionController::ContextMacros }
