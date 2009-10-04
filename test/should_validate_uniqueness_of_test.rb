require 'test_helper'

context "should_validate_presence_of" do
  context "without a persisted record" do
    setup_with_test_context do |test_ctx|
      test_ctx.setup { Room.new }
      test_ctx.should_validate_uniqueness_of :email
    end

    asserts("the test is a failure") { @test_context.assertions.first.failed? }

    should "require a persisted record before moving on" do
      @test_context.assertions.first.result.message
    end.equals("expected topic not to be a new record")
  end # without a persisted record
end # should_validate_presence_of
