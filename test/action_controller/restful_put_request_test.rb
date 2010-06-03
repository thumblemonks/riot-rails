require 'teststrap'

context "RESTful PUT request on resource" do

  context GremlinsController do
    setup { put("/gremlins/2") }

    asserts("request method") { request.request_method }.equals(:put)
    asserts("controller name") { controller.controller_name }.equals("gremlins")
    asserts("action name") { controller.action_name }.equals("update")
    asserts("id param") { controller.params["id"] }.equals("2")
    asserts("response body") { response.body }.equals("savin' money")
  end # on a top level resource

  context PartiesController do
    setup { put("/gremlins/2/parties/3", "foo" => "bar") }

    asserts("request method") { request.request_method }.equals(:put)
    asserts("controller name") { controller.controller_name }.equals("parties")
    asserts("action name") { controller.action_name }.equals("update")

    asserts("gremlin_id param") { controller.params["gremlin_id"] }.equals("2")
    asserts("id param") { controller.params["id"] }.equals("3")
    asserts("foo param") { controller.params["foo"] }.equals("bar")

    asserts("response body") { response.body }.equals("i'll put that over here")
  end # on a nested resource
end # RESTful PUT request
