require 'teststrap'

context "The belongs_to assertion macro" do
  setup_test_context
  setup { topic.asserts("room") { Room.new } }

  should("pass when record has a belongs_to association defined for attribute") do
    topic.belongs_to(:house).run(Riot::Situation.new)
  end.equals([:pass, "belongs to :house"])

  should("fail when record does not have a belongs_to association defined for attribute") do
    topic.belongs_to(:someone_else).run(Riot::Situation.new)
  end.equals([:fail, "expected :someone_else to be a belongs_to association"])

  should("fail when attribute is not a belongs_to, but is a has_one association") do
    topic.belongs_to(:floor).run(Riot::Situation.new)
  end.equals([:fail, "expected :floor to be a belongs_to association, but was a has_one instead"])
end # The has_many assertion macro
