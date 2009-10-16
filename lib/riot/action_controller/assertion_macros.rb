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
