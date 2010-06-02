require 'teststrap'

context RoomsController do

  asserts("unknown action for existing controller") do
    get "/rooms/blah"
  end.raises(AbstractController::ActionNotFound, "The action 'blah' could not be found")

  asserts("controller does not match the one under test") do
    get "/gremlins/2"
  end.raises(RiotRails::ActionController::ControllerMismatch, "Expected rooms controller, not gremlins")

  context "for a GET request" do
    helper(:action_name) { env['action_dispatch.request.path_parameters'][:action] }

    context "without with parameters" do
      setup { get "/rooms" }

      asserts("action name") { action_name }.equals("index")
      asserts("response status") { response.status }.equals(200)
      asserts("response body") { response.body }.equals("foo")

      context "response headers" do
        setup { response.headers.keys }
        asserts_topic.includes("Content-Type")
        asserts_topic.includes("ETag")
        asserts_topic.includes("Cache-Control")
      end # response headers
    end # without with parameters

    context "with parameters" do
      setup { get "/rooms/echo_params", {:name => "Juiceton", :foo => "blaz"} }

      asserts("action name") { action_name }.equals("echo_params")
      asserts("response body") { response.body }.equals("controller=rooms,foo=blaz,name=Juiceton")
    end # with with parameters

  end # for a GET request

end # RoomsController
