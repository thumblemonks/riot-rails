require 'teststrap'

context "The validates_presence_of assertion macro" do
  setup_test_context
  setup { topic.asserts("room") { Room.new } }

  should("pass when attribute requires presence") do
    topic.validates_presence_of(:location).run(Riot::Situation.new)
  end.equals([:pass, "validates presence of :location"])

  should("fail when attribute does not require presence") do
    topic.validates_presence_of(:contents).run(Riot::Situation.new)
  end.equals([:fail, "expected to validate presence of :contents", blah, blah])
end # The validates_presence_of assertion macro
