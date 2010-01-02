require 'teststrap'

context "The attribute_is_invalid macro" do
  setup_test_context

  should("fail when attribute is not invalid") do
    assertion = topic.asserts("room") { Room.new(:location => "barn burner") }
    assertion.attribute_is_invalid(:location, "not yet").run(Riot::Situation.new)
  end.equals([:fail, ":location expected to be invalid"])

  should("fail when attribute is invalid, but the message could not be found") do
    assertion = topic.asserts("room") { Room.new }
    assertion.attribute_is_invalid(:location, "child please").run(Riot::Situation.new)
  end.equals([:fail, %Q{:location is invalid, but "child please" is not a valid error message}])

  should("pass when attribute is invalid and error message is found") do
    assertion = topic.asserts("room") { Room.new }
    assertion.attribute_is_invalid(:location, "can't be blank").run(Riot::Situation.new)
  end.equals([:pass, %Q{:location is invalid}])
end # The attribute_is_invalid macro
