require 'test_helper'

context "should_allow_values_for" do
  setup do
    @test_report = Protest::NilReport.new
    @test_context = Protest::Context.new("test context", @test_report)
    @test_context.setup { Room.new }
  end

  context "when attribute allows a value" do
    setup do
      @test_context.should_allow_values_for :email, "a@b.cd"
      @test_context.report
      @test_report
    end

    should("pass 1 test") { topic.passes }.equals(1)
    should("have no failures") { topic.failures }.equals(0)
    should("have no errors") { topic.errors }.equals(0)
  end # when attribute allows a value

  context "when attribute allows multiple values" do
    setup do
      @test_context.should_allow_values_for :email, "a@b.cd", "e@f.gh"
      @test_context.report
      @test_report
    end

    should("pass 2 tests") { topic.passes }.equals(2)
    should("have no failures") { topic.failures }.equals(0)
    should("have no errors") { topic.errors }.equals(0)
  end # when attribute allows multiple values

  context "when attribute is provided a valid and an invalid value" do
    setup do
      @test_context.should_allow_values_for :email, "a", "e@f.gh"
      @test_context.report
      @test_report
    end

    should("pass 1 test") { topic.passes }.equals(1)
    should("have 1 failure") { topic.failures }.equals(1)
    should("have no errors") { topic.errors }.equals(0)
  end # when attribute allows multiple values
end # should_allow_values_for
