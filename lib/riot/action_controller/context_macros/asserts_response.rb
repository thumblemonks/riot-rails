module RiotRails
  module ActionController
    module AssertsResponse

      def asserts_response(method_name=nil)
        if method_name
          asserts("response ##{method_name.to_s}") { response.send(method_name) }
        else
          asserts("response") { response }
        end
      end

    end # AssertsResponse
  end # ActionController
end # RiotRails
