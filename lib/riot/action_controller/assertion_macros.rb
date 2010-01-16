module RiotRails
  module ActionController
    # Asserts that calling body on whatever is passed in matches the expected value. Expected value can be a
    # literal string or a regular expression. It makes most sense to provide this macro with the response.
    #
    #   rails_context UsersController do
    #     hookup { get :index }
    #     asserts(:response).renders("a bunch of html")
    #     asserts(:response).renders(/bunch of/)
    #   end
    class RendersMacro < Riot::AssertionMacro
      register :renders

      def evaluate(actual, expected)
        actual_body = actual.body
        if (expected.kind_of?(Regexp) ? (actual_body =~ expected) : (expected == actual_body))
          pass
        else
          verb = expected.kind_of?(Regexp) ? "match" : "equal"
          fail("expected response body #{actual_body.inspect} to #{verb} #{expected.inspect}")
        end
      end
    end

    # Asserts that the name you provide is the basename of the rendered template. For instance, if you
    # expect the rendered template is named "foo_bar.html.haml" and you pass "foo_bar" into
    # renders_template, the assertion would pass. If instead you pass "foo" into renders_template, the
    # assertion will fail. Using Rails' assert_template both assertions would pass.
    #
    # It's important to note that the actual value provided must respond to +#rendered+. It's best to run
    # this assertion on the response
    #
    #   rails_context ThingsController do
    #     hookup { get :index }
    #     asserts(:response).renders_template(:index)
    #     asserts(:response).renders_template("index")
    #     asserts(:response).renders_template("index.erb") # fails even if that's the name of the template
    #   end
    class RendersTemplateMacro < Riot::AssertionMacro
      register :renders_template
      
      def evaluate(actual, expected_name)
        name = expected_name.to_s
        actual_template_path = actual.rendered[:template].to_s
        actual_template_name = File.basename(actual_template_path)
        if actual_template_name.to_s.match(/^#{name}(\.\w+)*$/)
          pass("renders template #{name.inspect}")
        else
          fail("expected template #{name.inspect}, not #{actual_template_path.inspect}")
        end
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
    class ResponseCodeMacro < Riot::AssertionMacro
      register :response_code

      def evaluate(actual, expected_code)
        if expected_code.kind_of?(Symbol)
          expected_code = ::ActionController::StatusCodes::SYMBOL_TO_STATUS_CODE[expected_code]
        end
        actual_code = actual.response.response_code
        if expected_code == actual_code
          pass("returns response code #{expected_code}")
        else
          fail("expected response code #{expected_code}, not #{actual_code}")
        end
      end
    end

    # Asserts that the response from an action is a redirect and that the path or URL matches your
    # expectations. If the response code is not in the 300s, the assertion will fail. If the reponse code
    # is fine, but the redirect-to path or URL do not exactly match your expectation, the assertion will
    # fail.
    #
    # +redirected_to+ expects you to provide your expected path in a lambda. This is so you can use named
    # routes, which are - as it turns out - handy. It's also what I would expect to be able to do.
    #
    #   controlling :people
    #   setup do
    #     post :create, :person { ... }
    #   end
    #
    #   controller.redirected_to { person_path(...) }
    #
    # PS: There is a difference between saying +named_route_path+ and +named_route_url+ and Riot Rails will
    # be very strict (read: annoying) about it :)
    class RedirectedToMacro < Riot::AssertionMacro
      register :redirected_to
      def evaluate(actual, expected_redirect)
        actual_response_code = actual.response.response_code
        if (300...400).member?(actual_response_code)
          actual_redirect = actual.url_for(actual.response.redirected_to)
          msg = "expected to redirect to <#{expected_redirect}>, not <#{actual_redirect}>"
          expected_redirect == actual_redirect ? pass("redirected to #{expected_redirect}") : fail(msg)
        else
          fail("expected response to be a redirect, but was #{actual_response_code}")
        end
      end
    end

  end # ActionController
end # RiotRails
