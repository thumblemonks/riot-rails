require 'test_helper'

class Room < ActiveRecord::Base
  validates_presence_of :location
end

context "should_validate_presence_of" do
  setup do
    @test_report = Protest::NilReport.new
    @test_context = Protest::Context.new("test context", @test_report)
    @test_context.setup { Room.new }
  end

  context "when attribute requires presence" do
    setup do
      @test_context.should_validate_presence_of :location
      @test_context.report
      @test_report
    end

    should("pass 1 test") { topic.passes }.equals(1)
    should("have no failures") { topic.failures }.equals(0)
    should("have no errors") { topic.errors }.equals(0)
  end # when attribute requires presence

  context "when attribute does not require presence" do
    setup do
      @test_context.should_validate_presence_of :contents
      @test_context.report
      @test_report
    end

    should("pass no tests") { topic.passes }.equals(0)
    should("have 1 failure") { topic.failures }.equals(1)
    should("have no errors") { topic.errors }.equals(0)
  end # when attribute does not require presence
end # should_validate_presence_of
