require 'test_helper'

context "should_allow_values_for" do
  setup_and_run_context("when attribute allows a value", 1, 0, 0) do |ctx|
    ctx.setup { Room.new }
    ctx.should_allow_values_for :email, "a@b.cd"
  end

  setup_and_run_context("when attribute allows multiple values", 2, 0, 0) do |ctx|
    ctx.setup { Room.new }
    ctx.should_allow_values_for :email, "a@b.cd", "e@f.gh"
  end

  setup_and_run_context("when attribute is provided a valid and an invalid value", 1, 1, 0) do |ctx|
    ctx.setup { Room.new }
    ctx.should_allow_values_for :email, "a", "e@f.gh"
  end
end # should_allow_values_for

context "should_not_allow_values_for" do
  setup_and_run_context("when attribute does not allow a value", 1, 0, 0) do |ctx|
    ctx.setup { Room.new }
    ctx.should_not_allow_values_for :email, "a"
    ctx.assertions.each {|a| STDOUT.puts a.raised if a.errored?}
  end

  setup_and_run_context("when attribute does not allow multiple values", 2, 0, 0) do |ctx|
    ctx.setup { Room.new }
    ctx.should_not_allow_values_for :email, "a", "e"
  end

  setup_and_run_context("when attribute is provided a valid and an invalid value", 1, 1, 0) do |ctx|
    ctx.setup { Room.new }
    ctx.should_not_allow_values_for :email, "a", "e@f.gh"
  end
end # should_not_allow_values_for
