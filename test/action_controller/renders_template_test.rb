require 'teststrap'

class RenderedTemplatesController < ActionController::Base
  def foo_bar; end
  def text_me; render :text => "blah"; end
end

context "asserting the rendered template for an action" do

  setup do
    context = Riot::Context.new("rendered template", Riot::SilentReporter.new)
    context.controlling :rendered_templates
    context
  end

  context "that rendered a template" do
    setup do
      topic.setup { get :foo_bar }
      topic
    end

    should "pass when rendered template name matches expectation" do
      assertion = topic.controller
      assertion.renders_template('foo_bar')
      assertion.passed?
    end

    context "when rendered template does not match expectation" do
      setup do
        assertion = topic.controller
        assertion.renders_template('bar_foo')
        assertion
      end

      asserts("topic failed") { topic.failed? }

      asserts("topic message") do
        topic.result.message
      end.matches(/expected template "bar_foo", not "rendered_templates\/foo_bar.html.erb"/)
    end # when rendered template does not match expectation

  end # that rendered a template

  context "that did not render a template as expected" do
    setup do
      topic.setup { get :text_me }
      topic
    end

    should "pass when providing nil as expectation" do
      assertion = topic.controller
      assertion.renders_template(nil)
      assertion.passed?
    end

    should "pass when providing empty string as expectation" do
      assertion = topic.controller
      assertion.renders_template("")
      assertion.passed?
    end
  end # that did not render a template as expected

  context "that did not render a template but expected one" do
    setup do
      topic.setup { get :text_me }
      assertion = topic.controller
      assertion.renders_template('text_me')
      assertion
    end

    asserts("topic failed") { topic.failed? }

    asserts("topic message") do
      topic.result.message
    end.matches(/expected template "text_me", not ""/)
  end # that did not render a template but expected one

  context "that rendered a template with a partial match on template name" do
    setup do
      topic.setup { get :foo_bar }
      assertion = topic.controller
      assertion.renders_template('foo')
      assertion
    end

    asserts("topic failed") { topic.failed? }

    asserts("topic message") do
      topic.result.message
    end.matches(/expected template "foo", not "rendered_templates\/foo_bar.html.erb"/)
  end # that rendered a template with a partial match on template name

end # asserting the rendered template for an action
