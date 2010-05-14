RiotRails.register_context_helper do
  def prepare_context(context)
    if action_controller_context?(context)

      context.helper(:app) { @app }
      context.helper(:env) { @env }
      context.helper(:controller) { @controller }
      context.helper(:request) { @request }
      context.helper(:response) { @response }

      context.premium_setup do
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
      end

    end
  end
private
  def action_controller_context?(context)
    description = context.description
    description.kind_of?(Class) && description.ancestors.include?(::ActionController::Base)
  end
end
