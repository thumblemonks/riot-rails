require 'teststrap'

class RedirectedToController < ActionController::Base
  def index
    redirect_to new_gremlin_path
  end

  def show
    render :text => ""
  end
end

context "Asserting the redirect of an action" do

  setup do
    @situation = Riot::Situation.new
    context = Riot::Context.new("redirected to") {}
    context.controlling(:redirected_to).last.run(@situation)
    context
  end

  context "when doing an actual redirect" do
    setup do
      topic.setup { get :index }.last.run(@situation)
      topic
    end

    should "pass when expected url matches actual redirect url" do
      topic.asserts_controller.redirected_to(lambda { new_gremlin_path }).run(@situation)
    end.equals([:pass])

    should "fail with when expected url does not exactly matches actual redirect url" do
      topic.asserts_controller.redirected_to(
        lambda { new_gremlin_url } ).run(@situation)
    end.equals([:fail, "expected to redirect to <http://test.host/gremlins/new>, not </gremlins/new>"])

  end # when doing an actual redirect

  context "when not actually doing a redirect" do
    setup do
      topic.setup { get :show }.last.run(@situation)
      topic
    end
  
    should "fail with message about expecting a redirect" do
      topic.asserts_controller.redirected_to(lambda { new_gremlin_path }).run(@situation)
    end.equals([:fail, "expected response to be a redirect, but was 200"])
  end # when not actually doing a redirect

end # Asserting the redirect of an action
