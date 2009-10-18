require 'teststrap'

context "validates_presence_of" do
  setup_and_run_context("when attribute requires presence", 1, 0, 0) do |test_ctx|
    test_ctx.setup { Room.new }
    test_ctx.topic.validates_presence_of(:location)
  end

  setup_and_run_context("when attribute does not require presence", 0, 1, 0) do |test_ctx|
    test_ctx.setup { Room.new }
    test_ctx.topic.validates_presence_of(:contents)
  end
end # validates_presence_of
