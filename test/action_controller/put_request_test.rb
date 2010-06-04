require 'teststrap'

context RoomsController do

  asserts("PUTs unknown action for existing controller") do
    put "/rooms/blah"
  end.raises(AbstractController::ActionNotFound, "The action 'blah' could not be found")

  context "for a PUT request" do
    helper(:action_name) { env['action_dispatch.request.path_parameters'][:action] }

    context "without parameters" do
      setup { put "/rooms/update" }

      asserts("request method") { request.request_method }.equals("PUT")
      asserts("action name") { action_name }.equals("update")
      asserts("response status") { response.status }.equals(200)
      asserts("response body") { response.body }.equals { "updated #{controller.params.inspect}" }

      context "response headers" do
        setup { response.headers.keys }
        asserts_topic.includes("Content-Type")
        asserts_topic.includes("ETag")
        asserts_topic.includes("Cache-Control")
      end # response headers
    end # without parameters

    context "with parameters" do
      setup { put "/rooms/update", {:momma => "loves you", "love_you_too" => "mom"} }

      asserts("request method") { request.request_method }.equals("PUT")
      asserts("action name") { action_name }.equals("update")
      asserts("response status") { response.status }.equals(200)

      asserts("response body") { response.body }.equals do
        "updated #{controller.params.inspect}"
      end

      asserts("params") { controller.params }.includes("momma")
      asserts("params") { controller.params }.includes("love_you_too")
    end # with parameters

  end # for a PUT request

end # RoomsController
