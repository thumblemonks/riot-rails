require 'teststrap'

context "The belongs_to assertion macro" do
  setup_test_context
  setup { topic.asserts("room") { Room.new } }

  should("pass when record has a belongs_to association defined for attribute") do
    topic.belongs_to(:house).run(Riot::Situation.new)
  end.equals([:pass, ":house is a belongs_to association"])

  should("fail when record does not have a belongs_to association defined for attribute") do
    topic.belongs_to(:someone_else).run(Riot::Situation.new)
  end.equals([:fail, ":someone_else is not a belongs_to association"])

  should("fail when attribute is not a belongs_to, but is a has_one association") do
    topic.belongs_to(:floor).run(Riot::Situation.new)
  end.equals([:fail, ":floor is not a belongs_to association"])

  should("fail when association options are specified, but they do not match the record") do
    topic.belongs_to(:owner, :class_name => "Person").run(Riot::Situation.new)
  end.equals([:fail, %q[should belongs_to :owner with :class_name => "Person"]])
end # The has_many assertion macro
