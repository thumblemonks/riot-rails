require 'teststrap'

class FoosController < ActionController::Base
  def index
    @thing = "hoo ray"
    render :text => ''
  end
end

rails_context "A controller test" do
  controlling :foos

  asserts_controller.kind_of(FoosController)
  asserts_topic.kind_of(FoosController)

  asserts("request is accessible") { request }.kind_of(::ActionDispatch::TestRequest)
  asserts("response is accessible") { response }.kind_of(::ActionDispatch::TestResponse)
  asserts("params is accessible") { controller.params }.equals({})

  asserts("http method shortcut for get") { self }.responds_to(:get)
  asserts("http method shortcut for post") { self }.responds_to(:post)
  asserts("http method shortcut for put") { self }.responds_to(:put)
  asserts("http method shortcut for delete") { self }.responds_to(:delete)
  asserts("http method shortcut for xml_http_request") { self }.responds_to(:xml_http_request)
  asserts("http method shortcut for xhr") { self }.responds_to(:xhr)

  asserts("an unknown action call") do
    get :burberry
  end.raises(::ActionController::UnknownAction, "No action responded to burberry")
end # A controller test

rails_context "A controller test using class as argument" do
  controlling FoosController

  asserts_controller.kind_of(FoosController)
end # A controller test using class as argument

rails_context FoosController do
  hookup do
    @actual_class_name = topic.class.name
    get :index
  end

  asserts("actual class name") { @actual_class_name }.equals("FoosController")

  asserts_assigned(:thing).equals("hoo ray")
  asserts_assigned(:that).nil

  asserts_response.kind_of(::ActionDispatch::TestResponse)
  asserts_response(:response_code).equals(200)

  asserts_request.kind_of(::ActionDispatch::TestRequest)
  asserts_request(:cookies).kind_of(Hash)
end # A controller test with a hookup using the controller
