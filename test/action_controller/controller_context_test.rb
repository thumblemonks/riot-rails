require 'teststrap'

class FoosController < ActionController::Base
end

context "A controller test" do
  controlling :foos

  asserts_controller.kind_of(FoosController)

  asserts("request is accessible") { request }.kind_of(::ActionController::TestRequest)
  asserts("response is accessible") { response }.kind_of(::ActionController::TestResponse)
  asserts("params is accessible") { controller.params }.equals({})

  asserts("http method shortcut for get") { self }.respond_to(:get)
  asserts("http method shortcut for post") { self }.respond_to(:post)
  asserts("http method shortcut for put") { self }.respond_to(:put)
  asserts("http method shortcut for delete") { self }.respond_to(:delete)

  asserts("an unknown action call") do
    get :burberry
  end.raises(ActionController::UnknownAction, "No action responded to burberry")

end # a controller test
