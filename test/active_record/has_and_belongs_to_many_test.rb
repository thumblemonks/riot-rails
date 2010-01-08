require 'teststrap'

context "The has_and_belongs_to_many assertion macro" do
  setup_test_context
  setup { topic.asserts("room") { Room.new } }

  should("pass when record has a has_and_belongs_to_many association defined for attribute") do
    topic.has_and_belongs_to_many(:walls).run(Riot::Situation.new)
  end.equals([:pass, ":walls is a has_and_belongs_to_many association"])

  should("fail when record does not have a has_and_belongs_to_many association defined for attribute") do
    topic.has_and_belongs_to_many(:windows).run(Riot::Situation.new)
  end.equals([:fail, ":windows is not a has_and_belongs_to_many association"])

  should("fail when attribute is not a has_and_belongs_to_many, but is a has_many association") do
    topic.has_and_belongs_to_many(:doors).run(Riot::Situation.new)
  end.equals([:fail, ":doors is not a has_and_belongs_to_many association"])

  should("fail when association options are specified, but they do not match the record") do
    topic.has_and_belongs_to_many(:walls, :join_table => "blueprints").run(Riot::Situation.new)
  end.equals([:fail, %q[should has_and_belongs_to_many :walls with :join_table => "blueprints"]])
end # The has_and_belongs_to_many assertion macro
