require 'teststrap'

context "The has_one assertion macro" do
  setup_test_context
  setup { topic.asserts("room") { Room.new } }

  should("pass when record has a has_one association defined for attribute") do
    topic.has_one(:floor).run(Riot::Situation.new)
  end.equals([:pass, ":floor is a has_one association"])

  should("fail when record does not have a has_one association defined for attribute") do
    topic.has_one(:windows).run(Riot::Situation.new)
  end.equals([:fail, ":windows is not a has_one association"])

  should("fail when attribute is not a has_one, but is a has_many association") do
    topic.has_one(:doors).run(Riot::Situation.new)
  end.equals([:fail, ":doors is not a has_one association"])

  should("fail when association options are specified, but they do not match the record") do
    topic.has_one(:floor, :class_name => "Surface").run(Riot::Situation.new)
  end.equals([:fail, %q[should has_one :floor with :class_name => "Surface"]])
end # The has_one assertion macro
