require 'teststrap'

context "RESTful POST request on resource" do

  context GremlinsController do
    setup { post("/gremlins", :id => 2) }

    asserts("request method") { request.request_method }.equals("POST")
    asserts("controller name") { controller.controller_name }.equals("gremlins")
    asserts("action name") { controller.action_name }.equals("create")
    asserts("id param") { controller.params["id"] }.equals("2")
    asserts("response body") { response.body }.equals("makin' money")
  end # on a top level resource

  context PartiesController do
    setup { post("/gremlins/2/parties", "id" => 3) }

    asserts("request method") { request.request_method }.equals("POST")
    asserts("controller name") { controller.controller_name }.equals("parties")
    asserts("action name") { controller.action_name }.equals("create")
    asserts("gremlin_id param") { controller.params["gremlin_id"] }.equals("2")
    asserts("id param") { controller.params["id"] }.equals("3")
    asserts("response body") { response.body }.equals("give this monkey what he wants")
  end # on a nested resource
end # RESTful POST request
