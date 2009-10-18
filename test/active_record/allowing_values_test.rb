require 'teststrap'

context "allows_values_for" do
  setup_and_run_context("when attribute allows a value", 1, 0, 0) do |test_ctx|
    test_ctx.setup { Room.new }
    test_ctx.topic.allows_values_for :email, "a@b.cd"
  end

  setup_and_run_context("when attribute allows multiple values", 1, 0, 0) do |test_ctx|
    test_ctx.setup { Room.new }
    test_ctx.topic.allows_values_for :email, "a@b.cd", "e@f.gh"
  end

  setup_and_run_context("when attribute is provided a valid and an invalid value", 0, 1, 0) do |test_ctx|
    test_ctx.setup { Room.new }
    test_ctx.topic.allows_values_for :email, "a", "e@f.gh"
  end
end # allows_values_for

context "does_not_allow_values_for" do
  setup_and_run_context("when attribute does not allow a value", 1, 0, 0) do |test_ctx|
    test_ctx.setup { Room.new }
    test_ctx.topic.does_not_allow_values_for :email, "a"
    test_ctx.assertions.each {|a| STDOUT.puts a.raised if a.errored?}
  end

  setup_and_run_context("when attribute does not allow multiple values", 1, 0, 0) do |test_ctx|
    test_ctx.setup { Room.new }
    test_ctx.topic.does_not_allow_values_for :email, "a", "e"
  end

  setup_and_run_context("when attribute is provided a valid and an invalid value", 0, 1, 0) do |test_ctx|
    test_ctx.setup { Room.new }
    test_ctx.topic.does_not_allow_values_for :email, "a", "e@f.gh"
  end
end # does_not_allow_values_for
