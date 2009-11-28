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
