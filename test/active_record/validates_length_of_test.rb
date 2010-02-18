require 'teststrap'

context "The validates_length_of assertion macro" do
  setup_test_context
  setup { topic.asserts("room") { Room.new } }

  should("fail when minimum length causes an error") do
    topic.validates_length_of(:name, (4..15)).run(Riot::Situation.new)
  end.equals([:fail, ":name should be able to be 4 characters", blah, blah])

  should("fail when value less than minimum value does not cause an error") do
    topic.validates_length_of(:name, (6..15)).run(Riot::Situation.new)
  end.equals([:fail, ":name expected to be more than 5 characters", blah, blah])

  should("fail when maximum length causes an error") do
    topic.validates_length_of(:name, (5..21)).run(Riot::Situation.new)
  end.equals([:fail, ":name should be able to be 21 characters", blah, blah])

  should("fail when value greater than maximum value does not cause an error") do
    topic.validates_length_of(:name, (5..19)).run(Riot::Situation.new)
  end.equals([:fail, ":name expected to be less than 20 characters", blah, blah])

  should("pass when only a value can only be within the specific range") do
    topic.validates_length_of(:name, (5..20)).run(Riot::Situation.new)
  end.equals([:pass, "validates length of :name is within 5..20"])

  should("pass even when minimum value is zero") do
    topic.validates_length_of(:contents, (0..100)).run(Riot::Situation.new)
  end.equals([:pass, "validates length of :contents is within 0..100"])

end # The validates_length_of assertion macro
