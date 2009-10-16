require 'teststrap'

class RendersController < ActionController::Base
  def index; render :text => "Yo mama"; end
end

context "asserting the body of a response" do

  setup do
    context = Riot::Context.new("renders", Riot::NilReport.new)
    context.controlling :renders
    context.setup { get :index }
    context
  end

  should "assert rendered action body equals expected" do
    assertion = topic.controller
    assertion.renders("Yo mama")
    assertion.passed?
  end

  context "when rendered action body does not equal expected" do
    setup do
      assertion = topic.controller
      assertion.renders("Yo")
      assertion
    end

    asserts("topic failed") { topic.failed? }

    asserts("topic message") do
      topic.result.message
    end.matches(/expected response body "Yo mama" to equal "Yo"/)
  end # when rendered action body does not equal expected

  should "assert rendered action body matches expected" do
    assertion = topic.controller
    assertion.renders(/mama/)
    assertion.passed?
  end

  context "when rendered action body does not match expected" do
    setup do
      assertion = topic.controller
      assertion.renders(/obama/)
      assertion
    end

    asserts("topic failed") { topic.failed? }

    asserts("topic message") do
      topic.result.message
    end.matches(/expected response body "Yo mama" to match \/obama\//)
  end # when rendered action body does not match expected

end # asserting the body of a response
