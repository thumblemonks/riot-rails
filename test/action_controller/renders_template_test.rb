require 'teststrap'

class RenderedTemplatesController < ActionController::Base
  def foo_bar; end
  def text_me; render :text => "blah"; end
end

context "Asserting the rendered template for an action" do
  setup do
    @situation = Riot::Situation.new
    context = RiotRails::RailsContext.new("rendered_template") {}
    context.controlling(:rendered_templates).run(@situation)
    context
  end

  context "that rendered a template" do
    setup_for_assertion_test { get :foo_bar }

    assertion_test_passes("when rendered template name matches expectation", %Q{renders template "foo_bar"}) do
      topic.asserts_controller.renders_template('foo_bar')
    end

    assertion_test_fails("when rendered template does not match expectation",
    %Q{expected template "bar_foo", not "rendered_templates/foo_bar.html.erb"}) do
      topic.asserts_controller.renders_template('bar_foo')
    end
  end # that rendered a template

  context "that did not render a template, as was expected" do
    setup_for_assertion_test { get :text_me }

    assertion_test_passes("when providing nil as expectation", %Q{renders template ""}) do
      topic.asserts_controller.renders_template(nil)
    end

    assertion_test_passes("when providing empty string as expectation", %Q{renders template ""}) do
      topic.asserts_controller.renders_template("")
    end
  end # that did not render a template, as was expected

  context "that did not render a template but expected one" do
    setup_for_assertion_test { get :text_me }
    assertion_test_fails("with message", %Q{expected template "text_me", not ""}) do
      topic.asserts_controller.renders_template('text_me')
    end
  end # that did not render a template but expected one

  context "that rendered a template with a partial match on template name" do
    setup_for_assertion_test { get :foo_bar }

    assertion_test_fails("with message",
    %Q{expected template "foo", not "rendered_templates/foo_bar.html.erb"}) do
      topic.asserts_controller.renders_template('foo')
    end
  end # that rendered a template with a partial match on template name

end # Asserting the rendered template for an action
