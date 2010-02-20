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
    context = RiotRails::RailsContext.new("redirected to") {}
    context.controlling(:redirected_to).run(@situation)
    context
  end

  context "when doing an actual redirect" do
    hookup_for_assertion_test { get :index }

    assertion_test_passes("when expected url matches actual redirect url", "redirected to http://test.host/gremlins/new") do
      topic.asserts(:response).redirected_to { new_gremlin_url }
    end
  end # when doing an actual redirect

  context "when not actually doing a redirect" do
    hookup_for_assertion_test { get :show }
    assertion_test_fails("with message about expecting a redirect",
    "expected response to be a redirect, but was 200") do
      topic.asserts(:response).redirected_to { new_gremlin_path }
    end
  end # when not actually doing a redirect
end # Asserting the redirect of an action
