require 'teststrap'

context "testing has_many" do

  setup do
    context = Riot::Context.new("has_many test context", Riot::NilReport.new)
    context.setup { Room.new }
    context.topic
  end

  context "when record has a has_many association defined for attribute" do
    setup do
      topic.has_many(:doors)
      topic
    end
    
    asserts("assertion passed") { topic.passed? }
  end # when record has a has_many association defined for attribute

  context "when record does not have a has_many association defined for attribute" do
    setup do
      topic.has_many(:windows)
      topic
    end

    asserts("assertion failed") { topic.failed? }

    asserts("failure message") do
      topic.result.message
    end.matches(/expected :windows to be a has_many association, but was not/)
  end # when record does not have a has_many association defined for attribute

  context "when attribute is not a has_many, but is a has_one association" do
    setup do
      topic.has_many(:floor)
      topic
    end

    asserts("assertion failed") { topic.failed? }

    asserts("failure message") do
      topic.result.message
    end.matches(/expected :floor to be a has_many association, but was a has_one instead/)
  end # when attribute is not a has_many, but is a has_one association

end # testing has_many