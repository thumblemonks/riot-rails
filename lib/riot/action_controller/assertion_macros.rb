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
    end # AssertionMacros

  end # ActionController
end # Riot

Riot::Assertion.instance_eval { include Riot::ActionController::AssertionMacros }
