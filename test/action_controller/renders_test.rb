require 'teststrap'

class RendersController < ActionController::Base
  def index; render :text => "Yo mama"; end
end

context "Asserting the body of a response" do
  setup do
    @situation = Riot::Situation.new
    context = Riot::Context.new("renders") {}
    context.controlling(:renders).last.run(@situation)
    context.setup { get :index }.last.run(@situation)
    context
  end

  should "assert rendered action body equals expected" do
    topic.asserts_controller.renders("Yo mama").run(@situation)
  end.equals([:pass])

  should "fail when rendered action body does not equal expected" do
    topic.asserts_controller.renders("Yo").run(@situation)
  end.equals([:fail, %Q{expected response body "Yo mama" to equal "Yo"}])

  should "assert rendered action body matches expected" do
    topic.asserts_controller.renders(/mama/).run(@situation)
  end.equals([:pass])

  should "fail when rendered action body does not match expected" do
    topic.asserts_controller.renders(/obama/).run(@situation)
  end.equals([:fail, %Q{expected response body "Yo mama" to match /obama/}])

end # Asserting the body of a response
