require 'teststrap'

context RoomsController do

  asserts("POSTs unknown action for existing controller") do
    post "/rooms/blah"
  end.raises(AbstractController::ActionNotFound, "The action 'blah' could not be found")

  context "for a POST request" do
    helper(:action_name) { env['action_dispatch.request.path_parameters'][:action] }

    context "without parameters" do
      setup { post "/rooms/create" }

      asserts("request method") { request.request_method }.equals("POST")
      asserts("action name") { action_name }.equals("create")
      asserts("response status") { response.status }.equals(200)
      asserts("response body") { response.body }.equals { "created #{controller.params.inspect}" }

      context "response headers" do
        setup { response.headers.keys }
        asserts_topic.includes("Content-Type")
        asserts_topic.includes("ETag")
        asserts_topic.includes("Cache-Control")
      end # response headers
    end # without parameters

    context "with parameters" do
      setup { post "/rooms/create", {:momma => "loves you", "love_you_too" => "mom"} }

      asserts("request method") { request.request_method }.equals("POST")
      asserts("action name") { action_name }.equals("create")
      asserts("response status") { response.status }.equals(200)

      asserts("response body") { response.body }.equals do
        "created #{controller.params.inspect}"
      end

      asserts("params") { controller.params }.includes("momma")
      asserts("params") { controller.params }.includes("love_you_too")
    end # with parameters
    
    context "with nested parameters" do
      setup { post "/rooms/create", {:momma => {:loves => {:son => :yes, :daughter => :also} } } }
      
      asserts("params") { controller.params }.includes("momma")
      asserts("params") { controller.params[:momma] }.includes("loves")
      asserts("params") { controller.params[:momma][:loves] }.includes("son")
      asserts("params") { controller.params[:momma][:loves][:son] }.equals("yes")
      asserts("params") { controller.params[:momma][:loves] }.includes("daughter")
      asserts("params") { controller.params[:momma][:loves][:daughter] }.equals("also")
    end

  end # for a POST request

end # RoomsController
