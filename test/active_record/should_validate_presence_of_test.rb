require 'teststrap'

context "should_validate_presence_of" do
  setup_and_run_context("when attribute requires presence", 1, 0, 0) do |test_ctx|
    test_ctx.setup { Room.new }
    test_ctx.should_validate_presence_of :location
  end

  setup_and_run_context("when attribute does not require presence", 0, 1, 0) do |test_ctx|
    test_ctx.setup { Room.new }
    test_ctx.should_validate_presence_of :contents
  end

  setup_and_run_context("with multiple attributes required but not valid", 2, 0, 0) do |test_ctx|
    test_ctx.setup { Room.new }
    test_ctx.should_validate_presence_of :foo, :bar
  end
end # should_validate_presence_of
