require 'teststrap'

context RoomsController do
  context "for a GET request" do
    setup do
      get "/rooms/index"
    end

    asserts("action name") { env['action_dispatch.request.path_parameters'][:action] }.equals("index")

    asserts("response status") { response.status }.equals(200)
    asserts("response header") { response.header }.equals("Content-Type" => "text/html")
    asserts("response body") { response.body }.equals("foo")
  end

  asserts("unknown action for existing controller") do
    get "/rooms/blah"
  end.raises(AbstractController::ActionNotFound)

  asserts("controller does not the one under test") do
    get "/gremlins/index"
  end.raises(RiotRails::ActionController::ControllerMismatch, "Expected rooms controller, not gremlins")
end # RoomsController
