module RiotRails
  module ActionController
    class ControllerMismatch < Exception; end

    module HttpMethods
      def http_reset; @env = {}; end
      def get(uri, params={}) perform_request("GET", uri, params); end
      def post(uri, params={}) perform_request("POST", uri, params); end

      def put(uri, params={}); raise Exception, "PUT isn't ready yet"; end
      def delete(uri, params={}); raise Exception, "DELETE isn't ready yet"; end
    private
      def perform_request(request_method, uri, params)
        http_reset
        params = params.inject({}) { |acc,(key,val)| acc[key] = val.to_s; acc }
        @env = ::Rack::MockRequest.env_for(uri, {:params => params, :method => request_method})
        @env['action_dispatch.show_exceptions'] = false
        @app.call(@env)
      end
    end # HttpMethods
  end # ActionController

  module RackRequest
    def self.included(base)
      base.class_eval { alias :parameters :params }
    end
  end
end # RiotRails

Rack::Request.instance_eval { include RiotRails::RackRequest }
