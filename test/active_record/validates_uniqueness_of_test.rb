require 'teststrap'

context "The validates_uniqueness_of assertion macro" do
  setup_test_context

  should("fail without a persisted record") do
    topic.asserts("room") do
      Room.new(:email => "foo@bar.baz", :foo => "what")
    end.validates_uniqueness_of(:email).run(Riot::Situation.new)
  end.equals([:fail, "topic is not a new record when testing uniqueness of email"])

  should("pass with a persisted record") do
    topic.asserts("room") do
      Room.create_with_good_data(:email => "foo@bar.baz")
    end.validates_uniqueness_of(:email).run(Riot::Situation.new)
  end.equals([:pass])

  should("fail with a persisted record but not validating uniqueness") do
    topic.asserts("room") do
      Room.new(:email => "goo@car.caz")
    end.validates_uniqueness_of(:foo).run(Riot::Situation.new)
  end.equals([:fail, "topic is not a new record when testing uniqueness of foo"])
end # The validates_uniqueness_of assertion macro
