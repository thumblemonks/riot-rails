require 'teststrap'

class FoosController < ActionController::Base
end

context "controlling in a context" do

  setup do
    @ctx = Riot::Context.new("foo", Riot::NilReport.new)
    @ctx.controlling :foos
    @ctx.situation
  end

  topic.assigns(:controller)
  topic.assigns(:request)
  topic.assigns(:response)
  
  context "the assigned controller" do
    setup { topic.controller }

    topic.kind_of(FoosController)

    should("have an empty params hash") do
      topic.params
    end.equals({})

    should("return a test request when asking for request") do
      topic.request
    end.kind_of(::ActionController::TestRequest)
  end # the assigned controller

  context "the assigned request" do
    setup { topic.request }
    topic.kind_of(::ActionController::TestRequest)
  end # the assigned request

  context "the assigned response" do
    setup { topic.response }
    topic.kind_of(::ActionController::TestResponse)
  end # the assigned response

  context "calling controller" do
    setup { @ctx.controller }

    topic.kind_of(Riot::Assertion)

    asserts("assertion name") { topic.description }.equals("foo asserts controller")

    should("return the controller as the actual value") do
      topic.actual
    end.kind_of(FoosController)
  end # calling controller

end # controlling in a context

context "a controller test" do
  controlling :foos

  asserts("situation") { self }.respond_to(:get)
  asserts("situation") { self }.respond_to(:post)
  asserts("situation") { self }.respond_to(:put)
  asserts("situation") { self }.respond_to(:delete)

  asserts "an unknown action" do
    get :burberry
  end.raises(ActionController::UnknownAction, "No action responded to burberry")
end # a controller
