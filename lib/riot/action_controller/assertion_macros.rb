module Riot #:nodoc:
  module ActionController #:nodoc:

    module AssertionMacros
      # Asserts that the body of the response equals or matches the expected expression. Expects actual to
      # be the controller.
      #
      #   controller.renders("a bunch of html")
      #   controller.renders(/bunch of/)
      def renders(expected)
        actual_body = actual.response.body
        if expected.kind_of?(Regexp)
          msg = "expected response body #{actual_body.inspect} to match #{expected.inspect}"
          actual_body =~ expected || fail(msg)
        else
          msg = "expected response body #{actual_body.inspect} to equal #{expected.inspect}"
          expected == actual_body || fail(msg)
        end
      end

      # Asserts that the name you provide is the basename of the rendered template. For instance, if you
      # expect the rendered template is named "foo_bar.html.haml" and you pass "foo_bar" into
      # renders_template, the assertion would pass. If instead you pass "foo" into renders_template, the
      # assertion will fail. Using Rails' assert_template both assertions would pass
      #
      #   controlling :things
      #   controller.renders_template(:index)
      #   controller.renders_template("index")
      #   controller.renders_template("index.erb") # fails even if that's the name of the template
      def renders_template(name)
        name = name.to_s
        actual_template_path = actual.response.rendered[:template].to_s
        actual_template_name = File.basename(actual_template_path)
        msg = "expected template #{name.inspect}, not #{actual_template_path.inspect}"
        actual_template_name.to_s.match(/^#{name}(\.\w+)?$/) || fail(msg)
      end

      # Asserts that the HTTP response code equals your expectation. You can use the symbolized form of the
      # status code or the integer code itself. Not currently supporting status ranges; such as: +:success+,
      # +:redirect+, etc.
      #
      #   controller.response_code(:ok)
      #   controller.response_code(200)
      #   
      #   controller.response_code(:not_found)
      #   controller.response_code(404)
      #   
      #   # A redirect
      #   controller.response_code(:found)
      #   controller.response_code(302)
      #
      # See +ActionController::StatusCodes+ for the list of available codes.
      def response_code(expected_code)
        if expected_code.kind_of?(Symbol)
          expected_code = ::ActionController::StatusCodes::SYMBOL_TO_STATUS_CODE[expected_code]
        end
        actual_code = actual.response.response_code
        expected_code == actual_code || fail("expected response code #{expected_code}, not #{actual_code}")
      end
    end # AssertionMacros

  end # ActionController
end # Riot

Riot::Assertion.instance_eval { include Riot::ActionController::AssertionMacros }
