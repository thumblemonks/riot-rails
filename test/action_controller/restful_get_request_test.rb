require 'teststrap'

context "RESTful GET request on resource" do

  context GremlinsController do
    setup { get("/gremlins/1") }

    asserts("request method") { request.request_method }.equals("GET")
    asserts("controller name") { controller.controller_name }.equals("gremlins")
    asserts("action name") { controller.action_name }.equals("show")
    asserts("id param") { controller.params["id"] }.equals("1")
    asserts("response body") { response.body }.equals("show me the money")
  end # on a top level resource

  context PartiesController do
    setup { get("/gremlins/1/parties/2") }

    asserts("request method") { request.request_method }.equals("GET")
    asserts("controller name") { controller.controller_name }.equals("parties")
    asserts("action name") { controller.action_name }.equals("show")
    asserts("gremlin_id param") { controller.params["gremlin_id"] }.equals("1")
    asserts("id param") { controller.params["id"] }.equals("2")
    asserts("response body") { response.body }.equals("woot")
  end # on a nested resource
end # RESTful GET request
