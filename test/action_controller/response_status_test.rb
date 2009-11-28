require 'teststrap'

class ResponseCodesController < ActionController::Base
  def ok_go; render :text => ""; end
  def fffound; redirect_to "http://your.momshou.se"; end
  def make_me; render :text => "", :status => 201; end
end

context "Asserting the response status for an action" do
  setup do
    @situation = Riot::Situation.new
    context = Riot::Context.new("response status") {}
    context.controlling(:response_codes).last.run(@situation)
    context
  end

  context "returning OK" do
    setup_for_assertion_test { get :ok_go }

    assertion_test_passes("when asked if :ok") { topic.asserts_controller.response_code(:ok) }
    assertion_test_passes("when asked if 200") { topic.asserts_controller.response_code(200) }

    assertion_test_fails("when CONTINUE returned instead", %Q{expected response code 100, not 200}) do
      topic.asserts_controller.response_code(100)
    end
  end # returning OK

  context "that is redirecting" do
    setup_for_assertion_test { get :fffound }
    assertion_test_passes("when asked if :ok") { topic.asserts_controller.response_code(:found) }
    assertion_test_passes("when asked if 200") { topic.asserts_controller.response_code(302) }
  end # that is redirecting

  context "that has explicit status" do
    setup_for_assertion_test { get :make_me }
    assertion_test_passes("when asked if :created") { topic.asserts_controller.response_code(:created) }
    assertion_test_passes("when asked if 202") {topic.asserts_controller.response_code(201) }
  end # that has explicit status

end # Asserting the status of a response
