require 'teststrap'

class ResponseCodesController < ActionController::Base
  def ok_go; render :text => ""; end
  def fffound; redirect_to "http://your.momshou.se"; end
  def make_me; render :text => "", :status => 201; end
end

context "asserting the response status for an action" do

  setup do
    context = Riot::Context.new("response status", Riot::NilReport.new)
    context.controlling :response_codes
    context
  end

  context "returning OK" do
    setup do
      topic.setup { get :ok_go }
      topic
    end

    should "pass when asked if :ok" do
      assertion = topic.controller
      assertion.response_code(:ok)
      assertion.passed?
    end

    should "pass when asked if 200" do
      assertion = topic.controller
      assertion.response_code(200)
      assertion.passed?
    end

    context "but expected to return CONTINUE" do
      setup do
        assertion = topic.controller
        assertion.response_code(100)
        assertion
      end

      asserts("topic failed") { topic.failed? }

      asserts("topic message") do
        topic.result.message
      end.matches(/expected response code 100, not 200/)
    end # but expected to return CONTINUE
  end # returning OK

  context "that is redirecting" do
    setup do
      topic.setup { get :fffound }
      topic
    end

    should "pass when asked if :ok" do
      assertion = topic.controller
      assertion.response_code(:found)
      assertion.passed?
    end

    should "pass when asked if 200" do
      assertion = topic.controller
      assertion.response_code(302)
      assertion.passed?
    end
  end # that is redirecting

  context "that has explicit status" do
    setup do
      topic.setup { get :make_me }
      topic
    end

    should "pass when asked if :created" do
      assertion = topic.controller
      assertion.response_code(:created)
      assertion.passed?
    end

    should "pass when asked if 202" do
      assertion = topic.controller
      assertion.response_code(201)
      assertion.passed?
    end
  end # that has explicit status

end # asserting the status of a response
