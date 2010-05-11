RiotRails.register_context_helper do
  def prepare_context(context)
    if action_controller_context?(context)
      context.premium_setup do
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
