require 'teststrap'

class FoosController < ActionController::Base
end

context "controlling in a context" do
  setup do
    ctx = Riot::Context.new("description", Riot::NilReport.new)
    ctx.controlling :foos
    ctx.situation
  end

  topic.assigns(:controller)
  topic.assigns(:request)
  topic.assigns(:response)
  
  context "the assigned controller" do
    setup { topic.instance_variable_get("@controller") }
    topic.kind_of(FoosController)
  end # the assigned controller

  context "the assigned request" do
    setup { topic.instance_variable_get("@request") }
    topic.kind_of(::ActionController::TestRequest)
  end # the assigned request

  context "the assigned response" do
    setup { topic.instance_variable_get("@response") }
    topic.kind_of(::ActionController::TestResponse)
  end # the assigned response

end # controlling in a context

context "a controller" do
  controlling :foos

  asserts "an unknown action" do
    get :burberry
  end.raises(ActionController::UnknownAction, "No action responded to burberry")
end # a controller

# should "define an assertion that returns the controller" do
#   
# end
# 
