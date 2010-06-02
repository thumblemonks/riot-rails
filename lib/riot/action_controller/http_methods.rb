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
        @app.call(@env)
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
