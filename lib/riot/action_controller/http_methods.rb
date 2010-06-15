module RiotRails
  module ActionController
    module HttpMethods
      def http_reset; @env = {}; end
      def get(uri, params={}) perform_request("GET", uri, params); end
      def post(uri, params={}) perform_request("POST", uri, params); end
      def put(uri, params={}); perform_request("PUT", uri, params); end
      def delete(uri, params={}); perform_request("DELETE", uri, params); end
    private
      def perform_request(request_method, uri, params)
        params = params.inject({}) { |acc,(key,val)| acc[key] = val.to_s; acc }
        @env = ::Rack::MockRequest.env_for(uri, {:params => params, :method => request_method}).merge(@env)
        @env['action_dispatch.show_exceptions'] = false
        @app.call(@env).tap { |state| @response = state.last }
      end
    end # HttpMethods
  end # ActionController
end # RiotRails
