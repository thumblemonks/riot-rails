require 'teststrap'

class RenderedTemplatesController < ActionController::Base
  def foo_bar; end
  def text_me; render :text => "blah"; end
end

context "Asserting the rendered template for an action" do
  setup do
    @situation = Riot::Situation.new
    context = Riot::Context.new("rendered_template") {}
    context.controlling(:rendered_templates).last.run(@situation)
    context
  end

  context "that rendered a template" do
    setup do
      topic.setup { get :foo_bar }.last.run(@situation)
      topic
    end

    should "pass when rendered template name matches expectation" do
      topic.asserts_controller.renders_template('foo_bar').run(@situation)
    end.equals([:pass])

    should "fail when rendered template does not match expectation" do
      topic.asserts_controller.renders_template('bar_foo').run(@situation)
    end.equals([:fail, %Q{expected template "bar_foo", not "rendered_templates/foo_bar.html.erb"}])

  end # that rendered a template

  context "that did not render a template, as was expected" do
    setup do
      topic.setup { get :text_me }.last.run(@situation)
      topic
    end

    should "pass when providing nil as expectation" do
      topic.asserts_controller.renders_template(nil).run(@situation)
    end.equals([:pass])

    should "pass when providing empty string as expectation" do
      topic.asserts_controller.renders_template("").run(@situation)
    end.equals([:pass])
  end # that did not render a template, as was expected

  context "that did not render a template but expected one" do
    setup do
      topic.setup { get :text_me }.last.run(@situation)
      topic
    end

    should("fail with message") do
      topic.asserts_controller.renders_template('text_me').run(@situation)
    end.equals([:fail, %Q{expected template "text_me", not ""}])
  end # that did not render a template but expected one

  context "that rendered a template with a partial match on template name" do
    setup do
      topic.setup { get :foo_bar }.last.run(@situation)
      topic
    end

    should("fail with message") do
      topic.asserts_controller.renders_template('foo').run(@situation)
    end.equals([:fail, %Q{expected template "foo", not "rendered_templates/foo_bar.html.erb"}])

  end # that rendered a template with a partial match on template name

end # Asserting the rendered template for an action
