require 'teststrap'

context "The has_many assertion macro" do
  setup_test_context
  setup { topic.asserts("room") { Room.new } }

  should("pass when record has a has_many association defined for attribute") do
    topic.has_many(:doors).run(Riot::Situation.new)
  end.equals([:pass])

  should("fail when record does not have a has_many association defined for attribute") do
    topic.has_many(:windows).run(Riot::Situation.new)
  end.equals([:fail, "expected :windows to be a has_many association, but was not"])

  should("fail when attribute is not a has_many, but is a has_one association") do
    topic.has_many(:floor).run(Riot::Situation.new)
  end.equals([:fail, "expected :floor to be a has_many association, but was a has_one instead"])
end # The has_many assertion macro
