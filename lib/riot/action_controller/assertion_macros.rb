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
          fail expected_message.response_body(actual_body).to.push("#{verb} #{expected.inspect}")
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
        actual_template_path = Array(actual.template.rendered[:template]).map(&:inspect).first.to_s # yuck
        actual_template_name = File.basename(actual_template_path)
        if actual_template_name.to_s.match(%r[^#{name}(\.\w+)*$])
          pass new_message.renders_template(name)
        else
          fail expected_message.template(name).not(actual_template_path)
        end
      end
    end

    # Asserts that the HTTP response code equals your expectation. You can use the symbolized form of the
    # status code or the integer code itself. Not currently supporting status ranges; such as: +:success+,
    # +:redirect+, etc.
    #
    # It's important to note that the actual value provided must respond to +#response_code+. It's best to
    # run this assertion on the response
    #
    #   asserts(:response).code(:ok)
    #   asserts(:response).code(200)
    #   
    #   asserts(:response).code(:not_found)
    #   asserts(:response).code(404)
    #   
    #   # A redirect
    #   asserts(:response).code(:found)
    #   asserts(:response).code(302)
    #
    # See +ActionController::StatusCodes+ for the list of available codes.
    class ResponseCodeMacro < Riot::AssertionMacro
      register :code

      def evaluate(actual, expected_code)
        if expected_code.kind_of?(Symbol)
          expected_code = ::Rack::Utils::SYMBOL_TO_STATUS_CODE[expected_code]
        end
        actual_code = actual.response_code
        if expected_code == actual_code
          pass("returns response code #{expected_code}")
        else
          fail("expected response code #{expected_code}, not #{actual_code}")
        end
      end
    end

    # Asserts that the response from an action is a redirect and that the path or URL matches your
    # expectations. If the response code is not in the 300s, the assertion will fail. If the ressponse code
    # is fine, but the redirect-to path or URL do not exactly match your expectation, the assertion will
    # fail.
    #
    # In order to use named routes which are handy, provide the path in a block. +redirected_to+ expects the
    # actual value to quack like a response object, which means it must respond to +response_code+ and
    # +redirected_to+.
    #
    #   rails_context PeopleController do
    #     hookup do
    #       post :create, :person { ... }
    #     end
    #
    #     asserts(:response).redirected_to { person_path(...) }
    #   end
    #
    # PS: There is a difference between saying +named_route_path+ and +named_route_url+ and Riot Rails will
    # be very strict (read: annoying) about it :)
    class RedirectedToMacro < Riot::AssertionMacro
      register :redirected_to

      def evaluate(actual, expected_redirect)
        actual_response_code = actual.response_code
        if (300...400).member?(actual_response_code)
          actual_redirect = actual.redirected_to
          msg = "expected to redirect to <#{expected_redirect}>, not <#{actual_redirect}>"
          expected_redirect == actual_redirect ? pass("redirected to #{expected_redirect}") : fail(msg)
        else
          fail("expected response to be a redirect, but was #{actual_response_code}")
        end
      end
    end

  end # ActionController
end # RiotRails
