module RiotRails
  class ActionControllerMiddleware < Riot::ContextMiddleware
    register

    def handle?(context)
      description = context.description
      description.kind_of?(Class) && description.ancestors.include?(::ActionController::Base)
    end # handle?

    def call(context)
      setup_context_macros(context)
      setup_situation(context)
    end
  private
    def setup_context_macros(context)
      context.class_eval do
        include RiotRails::ActionController::AssertsResponse
      end
    end

    def setup_situation(context)
      context.helper(:app) { @app }
      context.helper(:env) { @env }
      context.helper(:controller) { @controller }
      context.helper(:request) { @request }
      context.helper(:response) { last_response }

      context.setup(true) do
        self.class_eval do
          include Rack::Test::Methods
          include RiotRails::ActionController::HttpMethods
        end

        @env = {}
        @controller = context.description.new.tap do |controller|
          controller.request = @request = Rack::Request.new(@env).tap { |rq| rq.session }
          @response = Rack::Response.new
        end
        @app = context.description
      end # context.setup(true)
    end # call

  end # ActionControllerMiddleware
end # RiotRails
