require 'teststrap'

context "Transactional middleware" do
  setup { Riot::Context.new("Room") { set :transactional, true } }
  # hookup { topic.transaction { |&block| raise Exception, "Hello" } }

  asserts("context execution is wrapped in a transaction to be rolled back")

  # asserts(:transactional?)
  # 
  # asserts("calling local run") do
  #   topic.local_run(Riot::SilentReporter.new, Riot::Situation.new)
  # end.raises(Exception, "Hello")
  # 
  # context "with a child context" do
  #   setup do
  #     topic.context("call me a submarine") {}
  #   end
  #   asserts(:transactional?)
  # end
end # Transactional middleware
