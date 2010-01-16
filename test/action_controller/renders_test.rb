require 'teststrap'

class RendersController < ActionController::Base
  def index; render :text => "Yo mama"; end
end

context "Asserting the body of a response" do
  setup do
    @situation = Riot::Situation.new
    context = RiotRails::RailsContext.new("renders") {}
    context.controlling(:renders).run(@situation)
    context.hookup { get :index }.run(@situation)
    context
  end

  assertion_test_passes("when body equals expected") { topic.asserts(:response).renders("Yo mama") }

  assertion_test_fails("when rendered action body does not equal expected",
  %Q{expected response body "Yo mama" to equal "Yo"}) do
    topic.asserts(:response).renders("Yo")
  end

  assertion_test_passes("when body matches expected") { topic.asserts(:response).renders(/mama/) }

  assertion_test_fails("when rendered action body does not match expected",
  %Q{expected response body "Yo mama" to match /obama/}) do
    topic.asserts(:response).renders(/obama/)
  end

end # Asserting the body of a response
