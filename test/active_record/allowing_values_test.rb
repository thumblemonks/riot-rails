require 'teststrap'

context "The allow_values_for assertion macro" do
  setup_test_context
  setup { topic.asserts("room") { Room.new } }

  should("pass when attribute allows a value") do
    topic.allows_values_for(:email, "a@b.cd").run(Riot::Situation.new)
  end.equals([:pass, ""])

  should("pass when attribute allows multiple values") do
    topic.allows_values_for(:email, "a@b.cd", "e@f.gh").run(Riot::Situation.new)
  end.equals([:pass, ""])

  should("fail when attribute is provided a valid and an invalid value") do
    topic.allows_values_for(:email, "a", "e@f.gh").run(Riot::Situation.new)
  end.equals([:fail, %Q{expected :email to allow values ["a"]}, blah, blah])
end # The allow_values_for assertion macro

context "The does_not_allow_values_for assertion macro" do
  setup_test_context
  setup { topic.asserts("room") { Room.new } }

  should("pass when attribute does not allow a value") do
    topic.does_not_allow_values_for(:email, "a").run(Riot::Situation.new)
  end.equals([:pass, ""])

  should("pass when attribute does not allow multiple values") do
    topic.does_not_allow_values_for(:email, "a", "e").run(Riot::Situation.new)
  end.equals([:pass, ""])

  should("fail when attribute is provided a valid and an invalid value") do
    topic.does_not_allow_values_for(:email, "a", "e@f.gh").run(Riot::Situation.new)
  end.equals([:fail, %Q{expected :email not to allow values ["e@f.gh"]}, blah, blah])
end # The does_not_allow_values_for assertion macro

context "The is_invalid_when assertion macro" do
  setup_test_context
  setup { topic.asserts("room") { Room.new } }

  should("pass when attribute is invalid") do
    topic.is_invalid_when(:email, "fake").run(Riot::Situation.new)
  end.equals([:pass, %Q{attribute :email is invalid}])

  should("pass when error message equals one in its list of errors") do
    topic.is_invalid_when(:email, "fake", "is invalid").run(Riot::Situation.new)
  end.equals([:pass, %Q{attribute :email is invalid}])

  should("pass when error message matches one in its list of errors") do
    topic.is_invalid_when(:email, "fake", /invalid/).run(Riot::Situation.new)
  end.equals([:pass, %Q{attribute :email is invalid}])

  should("fail when attribute is valid") do
    topic.is_invalid_when(:email, "a@b.cd", "is invalid").run(Riot::Situation.new)
  end.equals([:fail, %Q{expected :email to be invalid when value is "a@b.cd"}, blah, blah])

  should("fail when exact error message not found") do
    topic.is_invalid_when(:email, "fake", "can't be blank").run(Riot::Situation.new)
  end.equals([:fail, %Q{expected :email to be invalid with error message "can't be blank"}, blah, blah])

  should("fail when error message not matched to returned errors") do
    topic.is_invalid_when(:email, "fake", /blank/).run(Riot::Situation.new)
  end.equals([:fail, %Q{expected :email to be invalid with error message /blank/}, blah, blah])
end # The is_invalid_when assertion macro
