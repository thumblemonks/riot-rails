require 'teststrap'

context "The validates_uniqueness_of assertion macro" do
  setup_test_context

  should("fail without a persisted record") do
    topic.asserts("room") do
      Room.new(:email => "foo@bar.baz")
    end.validates_uniqueness_of(:email).run(Riot::Situation.new)
  end.equals([:fail, "must use a persisted record when testing uniqueness of :email", blah, blah])

  should("pass with a persisted record") do
    topic.asserts("room") do
      Room.create_with_good_data(:email => "foo@bar.baz")
    end.validates_uniqueness_of(:email).run(Riot::Situation.new)
  end.equals([:pass, ":email is unique"])

  should("fail with a persisted record but not validating uniqueness") do
    topic.asserts("room") do
      Room.create_with_good_data(:email => "goo@car.caz")
    end.validates_uniqueness_of(:foo).run(Riot::Situation.new)
  end.equals([:fail, "expected to fail because :foo is not unique", blah, blah])
end # The validates_uniqueness_of assertion macro
