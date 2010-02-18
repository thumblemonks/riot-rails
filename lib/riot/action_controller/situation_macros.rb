module RiotRails #:nodoc:
  module ActionController #:nodoc:

    module HttpSupport
      attr_reader :controller, :request, :response
      
      # Simulates a GET HTTP request and handles response
      def get(*args)
      end

      # Simulates a POST HTTP request and handles response
      def post(*args)
      end

      # Simulates a PUT HTTP request and handles response
      def put(*args)
      end

      # Simulates a DELETE HTTP request and handles response
      def delete(*args)
      end

      # Simulates a HEAD HTTP request and handles response
      def head(*args)
      end

      # Simulates an XML HTTP Request (which allows for AJAX ya'll) for whatever HTTP method you want
      def xml_http_request(request_method, *args)
      end
      alias :xhr :xml_http_request
    private
      # def submit_request(http_method, action, parameters = nil, session = nil, flash = nil)
    end # HttpSupport

  end # ActionController
end # RiotRails

Riot::Situation.instance_eval do
  include ActionDispatch::TestProcess
  include RiotRails::ActionController::HttpSupport
end
