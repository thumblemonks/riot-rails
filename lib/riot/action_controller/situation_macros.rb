module RiotRails #:nodoc:
  module ActionController #:nodoc:

    # Nabbed form actionpack-3.0.0.beta
    module HttpSupport
      attr_reader :controller, :request, :response
      
      # Simulates a GET HTTP request and handles response
      def get(*args) submit_request("GET", *args); end

      # Simulates a POST HTTP request and handles response
      def post(*args) submit_request("POST", *args); end

      # Simulates a PUT HTTP request and handles response
      def put(*args) submit_request("PUT", *args); end

      # Simulates a DELETE HTTP request and handles response
      def delete(*args) submit_request("DELETE", *args); end

      # Simulates a HEAD HTTP request and handles response
      def head(*args) submit_request("HEAD", *args); end

      # Simulates an XML HTTP Request (which allows for AJAX ya'll) for whatever HTTP method you want
      def xml_http_request(request_method, *args)
        # @request.env['HTTP_X_REQUESTED_WITH'] = 'XMLHttpRequest'
        # @request.env['HTTP_ACCEPT'] ||=  [Mime::JS, Mime::HTML, Mime::XML, 'text/xml', Mime::ALL].join(', ')
        # returning submit_request(request_method.to_s.upcase, *args) do
        #   @request.env.delete 'HTTP_X_REQUESTED_WITH'
        #   @request.env.delete 'HTTP_ACCEPT'
        # end
      end
      alias :xhr :xml_http_request
    private
      def submit_request(http_method, action, parameters = nil, session = nil, flash = nil)
        @request.recycle!
        @response.recycle!
        @controller.response_body = nil
        @controller.formats = nil
        @controller.params = nil

        @html_document = nil
        @request.env['REQUEST_METHOD'] = http_method

        parameters ||= {}
        @request.assign_parameters(@controller.class.name.underscore.sub(/_controller$/, ''), action.to_s, parameters)

        @request.session = ActionController::TestSession.new(session) unless session.nil?
        @request.session["flash"] = @request.flash.update(flash || {})
        @request.session["flash"].sweep

        @controller.request = @request
        @controller.params.merge!(parameters)
        build_request_uri(action, parameters)
        ::ActionController::Base.class_eval { include ::ActionController::Testing }
        @controller.process_with_new_base_test(@request, @response)
        @request.session.delete('flash') if @request.session['flash'].blank?
        @response
      end

      def build_request_uri(action, parameters)
        unless @request.env['REQUEST_URI']
          options = @controller.__send__(:rewrite_options, parameters)
          options.update(:only_path => true, :action => action)

          url = ::ActionController::UrlRewriter.new(@request, parameters)
          @request.request_uri = url.rewrite(options)
        end
      end
    end # HttpSupport

  end # ActionController
end # RiotRails

Riot::Situation.instance_eval do
  include RiotRails::ActionController::HttpSupport
  include ::ActionController::UrlFor
  default_url_options[:host] = "test.host"
end
