require 'teststrap'

context "An asserts_response context macro" do
  context "for context not representing an ActionController" do
    setup { Riot::Context.new("Hello") {} }
    asserts("asserts_response returns") { topic.asserts_response }.raises(NoMethodError)
  end # for context not representing an ActionController

  setup { Riot::Context.new(RoomsController) {} }

  asserts("asserts_response returns") { topic.asserts_response }.kind_of(Riot::Assertion)

  asserts("the result of assertion responds to :status") do
    situation = Riot::Situation.new
    situation.helper(:response) { OpenStruct.new(:status => 200) }
    topic.asserts_response.responds_to(:status).run(situation).first
  end.equals(:pass)
end # An asserts_response context macro
