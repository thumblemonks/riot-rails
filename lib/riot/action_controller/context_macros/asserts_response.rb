module RiotRails
  module ActionController
    module AssertsResponse

      def asserts_response
        asserts("response") { response }
      end

    end # AssertsResponse
  end # ActionController
end # RiotRails
