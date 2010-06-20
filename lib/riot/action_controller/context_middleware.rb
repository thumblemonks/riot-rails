module RiotRails
  class ActionControllerMiddleware < Riot::ContextMiddleware
    register

    def call(context)
      setup_situation(context) if handle?(context.description)
      setup_context_macros(context) if nested_handle?(context)
      middleware.call(context)
    end
  private
    def handle?(description)
      description.kind_of?(Class) && description.ancestors.include?(::ActionController::Base)
    end

    # Walking the description chain looking to see if any of them are serviceable
    #
    # TODO: see if we can't define a method on the context to observe instead of calling
    # action_controller_description? each time
    def nested_handle?(context)
      (handle?(context.description) || nested_handle?(context.parent)) if context.respond_to?(:description)
    end

    def setup_context_macros(context)
      context.class_eval { include RiotRails::ActionController::AssertsResponse }
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
