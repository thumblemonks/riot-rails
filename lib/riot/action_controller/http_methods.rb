module RiotRails
  module ActionController
    class ControllerMismatch < Exception; end

    module HttpMethods
      def http_reset
        @env = {}
      end

      def get(uri, params={}, &block)
        http_reset
        @env = ::Rack::MockRequest.env_for(uri, {:params => params})
        @env['action_dispatch.show_exceptions'] = false
        returning(@app.call(@env)) do |call_response|
          c = @env["action_controller.instance"]
          unless c.class.controller_name == topic.controller_name
            msg = "Expected #{topic.controller_name} controller, not #{c.class.controller_name}"
            raise ControllerMismatch, msg
          end
        end
      end

      def post; raise Exception, "POST isn't ready yet"; end
      def put; raise Exception, "PUT isn't ready yet"; end
      def delete; raise Exception, "DELETE isn't ready yet"; end
    end # HttpMethods
  end # ActionController

  module RackRequest
    def self.included(base)
      base.class_eval { alias :parameters :params }
    end
  end
end # RiotRails

Rack::Request.instance_eval { include RiotRails::RackRequest }
