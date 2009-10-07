require 'test_helper'

context "should_validate_uniqueness_of" do

  setup_and_run_context("without a persisted record", 0, 2, 0) do |test_ctx|
    test_ctx.setup { Room.new(:email => "foo@bar.baz") }
    test_ctx.should_validate_uniqueness_of :email
  end

  setup_and_run_context("with a persisted record", 2, 0, 0) do |test_ctx|
    test_ctx.setup { Room.create_with_good_data(:email => "foo@bar.baz") }
    test_ctx.should_validate_uniqueness_of :email
  end

  setup_and_run_context("with a persisted record but not validating uniqueness", 1, 1, 0) do |test_ctx|
    test_ctx.setup { Room.create_with_good_data(:email => "goo@car.caz") }
    test_ctx.should_validate_uniqueness_of :foo
  end

end # should_validate_presence_of
