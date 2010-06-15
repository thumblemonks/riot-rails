module RiotRails
  class ActionControllerMiddleware < Riot::ContextMiddleware
    register

    def call(context)
      if handle?(context)
        setup_context_macros(context)
        setup_situation(context)
      end
      middleware.call(context)
    end
  private
    def handle?(context)
      description = context.description
      description.kind_of?(Class) && description.ancestors.include?(::ActionController::Base)
    end

    def setup_context_macros(context)
      context.class_eval do
        include RiotRails::ActionController::AssertsResponse
      end
    end

    def setup_situation(context)
      context.helper(:app) { @app }
      context.helper(:env) { @env }
      context.helper(:controller) do
        env["action_controller.instance"] || raise(Exception, "Instance of controller not found")
      end

      context.helper(:request) { controller.request }
      context.helper(:response) { @response || raise(Exception, "No response found") }

      context.setup(true) do
        self.class_eval { include RiotRails::ActionController::HttpMethods }
        @app = ::Rails.application
        http_reset
        context.description
      end # context.setup(true)
    end # call

  end # ActionControllerMiddleware
end # RiotRails
