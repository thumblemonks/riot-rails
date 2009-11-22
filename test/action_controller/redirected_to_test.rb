require 'teststrap'

class RedirectedToController < ActionController::Base
  def index; redirect_to new_gremlin_path; end
  def show; render :text => ""; end
end

context "asserting the redirect of an action" do

  setup do
    context = Riot::Context.new("redirected to", Riot::SilentReporter.new)
    context.controlling :redirected_to
    context
  end

  context "when doing an actual redirect" do

    setup do
      topic.setup { get :index }
      topic
    end

    should "pass when expected url matches actual redirect url" do
      assertion = topic.controller
      assertion.redirected_to { new_gremlin_path }
      assertion.passed?
    end

    context "and expected url does not match actual redirect url exactly" do
      setup do
        assertion = topic.controller
        assertion.redirected_to { new_gremlin_url }
        assertion
      end

      asserts("topic failed") { topic.failed? }

      asserts("topic message") do
        topic.result.message
      end.matches(%r[expected to redirect to <http://test.host/gremlins/new>, not </gremlins/new>])
    end # and expected url does not match actual redirect url exactly

  end # when doing an actual redirect

  context "when not actually doing a redirect" do
    setup do
      topic.setup { get :show }
      assertion = topic.controller
      assertion.redirected_to { new_gremlin_path }
      assertion
    end

    asserts("topic failed") { topic.failed? }

    asserts("topic message") do
      topic.result.message
    end.matches(%r[expected response to be a redirect, but was 200])
  end # when not actually doing a redirect

end # asserting the redirect of an action
