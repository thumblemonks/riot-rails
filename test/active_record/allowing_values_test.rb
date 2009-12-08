require 'teststrap'

context "The allow_values_for assertion macro" do
  setup_test_context
  setup { topic.asserts("room") { Room.new } }

  should("pass when attribute allows a value") do
    topic.allows_values_for(:email, "a@b.cd").run(Riot::Situation.new)
  end.equals([:pass])

  should("pass when attribute allows multiple values") do
    topic.allows_values_for(:email, "a@b.cd", "e@f.gh").run(Riot::Situation.new)
  end.equals([:pass])

  should("fail when attribute is provided a valid and an invalid value") do
    topic.allows_values_for(:email, "a", "e@f.gh").run(Riot::Situation.new)
  end.equals([:fail, %Q{expected :email to allow value(s) ["a"]}])
end # The allow_values_for assertion macro

context "The does_not_allow_values_for assertion macro" do
  setup_test_context
  setup { topic.asserts("room") { Room.new } }

  should("pass when attribute does not allow a value") do
    topic.does_not_allow_values_for(:email, "a").run(Riot::Situation.new)
  end.equals([:pass])

  should("pass when attribute does not allow multiple values") do
    topic.does_not_allow_values_for(:email, "a", "e").run(Riot::Situation.new)
  end.equals([:pass])

  should("fail when attribute is provided a valid and an invalid value") do
    topic.does_not_allow_values_for(:email, "a", "e@f.gh").run(Riot::Situation.new)
  end.equals([:fail, %Q{expected :email not to allow value(s) ["e@f.gh"]}])
end # The does_not_allow_values_for assertion macro

context "The allow_bad_value assertion macro" do
  setup_test_context
  setup { topic.asserts("room") { Room.new } }

  should("pass when invalid attribute's error msg is in its list of errors") do
    topic.allow_bad_value(:email, "fake", "is invalid").run(Riot::Situation.new)
  end.equals([:pass])

  should("pass when invalid attribute's error msg matches one in its list of errors") do
    topic.allow_bad_value(:email, "fake", "is invalid").run(Riot::Situation.new)
  end.equals([:pass])

  should("when attribute is valid") do
    topic.allow_bad_value(:email, "a@b.cd", "is invalid").run(Riot::Situation.new)
  end.equals([:fail, "expected :email be invalid with value a@b.cd and error msg is invalid"])

  should("fail when error msg is not in the list of attribute's errors") do
    topic.allow_bad_value(:email, "fake", "can't be blank").run(Riot::Situation.new)
  end.equals([:fail, "expected :email be invalid with value fake and error msg can't be blank"])
end # The allow_bad_value assertion macro
