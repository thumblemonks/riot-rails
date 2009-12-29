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
    context.controlling(:response_codes).run(@situation)
    context
  end

  context "returning OK" do
    setup_for_assertion_test { get :ok_go }

    assertion_test_passes("when asked if :ok", "returns response code 200") do
      topic.asserts_controller.response_code(:ok)
    end

    assertion_test_passes("when asked if 200", "returns response code 200") do
      topic.asserts_controller.response_code(200)
    end

    assertion_test_fails("when CONTINUE returned instead", %Q{expected response code 100, not 200}) do
      topic.asserts_controller.response_code(100)
    end
  end # returning OK

  context "that is redirecting" do
    setup_for_assertion_test { get :fffound }

    assertion_test_passes("when asked if :found", "returns response code 302") do
      topic.asserts_controller.response_code(:found)
    end

    assertion_test_passes("when asked if 302", "returns response code 302") do
      topic.asserts_controller.response_code(302)
    end
  end # that is redirecting

  context "that has explicit status" do
    setup_for_assertion_test { get :make_me }

    assertion_test_passes("when asked if :created", "returns response code 201") do
      topic.asserts_controller.response_code(:created)
    end

    assertion_test_passes("when asked if 201", "returns response code 201") do
      topic.asserts_controller.response_code(201)
    end
  end # that has explicit status

end # Asserting the status of a response
