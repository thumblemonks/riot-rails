require 'teststrap'

context "An asserts_response context macro" do
  context "for context not representing an ActionController" do
    setup { Riot::Context.new("Hello") {} }
    asserts("asserts_response returns") { topic.asserts_response }.raises(NoMethodError)
  end # for context not representing an ActionController

  helper(:situation) do
    a_situation = Riot::Situation.new
    a_situation.helper(:response) { OpenStruct.new(:status => 200) }
    a_situation
  end

  setup do
    Riot::Context.new(RoomsController) {}
  end

  context "when referenced without arguments" do
    setup { topic.asserts_response }

    asserts_topic.kind_of(Riot::Assertion)
    asserts(:to_s).equals("asserts response")

    asserts("the result of assertion responds to :status") do
      topic.responds_to(:status).run(situation).first
    end.equals(:pass)
  end # when referenced without arguments

  context "with method name provided" do
    setup { topic.asserts_response(:status).equals(200) }
    asserts(:to_s).equals("asserts response #status")
    asserts("output of running the test") { topic.run(situation).first }.equals(:pass)
  end

  context "used in the child context of an ActionController context" do
    setup do
      child_context = topic.context("child") {}
      child_context.asserts_response.run(situation)
    end
  
    asserts_topic.equals([:pass, ""])
  end # used in the child context of an ActionController context
end # An asserts_response context macro
