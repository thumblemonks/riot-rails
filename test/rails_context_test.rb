require 'teststrap'

context "The basic RailsContext" do
  setup do
    RiotRails::RailsContext.new("Room") { }
  end

  asserts_topic.kind_of(Riot::Context)
  asserts(:transactional?).not!
end # The basic RailsContext

context "The transactional RailsContext" do
  setup { RiotRails::RailsContext.new("Room") { set :transactional, true } }
  hookup { topic.transaction { |&block| raise Exception, "Hello" } }

  asserts(:transactional?)

  asserts("calling local run") do
    topic.local_run(Riot::SilentReporter.new, Riot::Situation.new)
  end.raises(Exception, "Hello")

  context "with a child context" do
    setup do
      topic.context("call me a submarine") {}
    end
    asserts(:transactional?)
  end
end # The transactional RailsContext

context "The rails_context macro" do
  setup_test_context

  asserts("Object") { Object }.respond_to(:rails_context)

  asserts("a new Riot::Context") { Riot::Context.new("foo") {} }.respond_to(:rails_context)

  asserts("its description") do
    Riot::Context.new("foo") {}.rails_context(Room) {}.description
  end.equals(Room)

  asserts("its detailed description") do
    Riot::Context.new("foo") {}.rails_context(Room) {}.detailed_description
  end.equals("foo Room")

  asserts("its type") do
    Riot::Context.new("foo") {}.rails_context(Room) {}
  end.kind_of(RiotRails::RailsContext)

  context "with description as a string" do
    setup do
      situation = Riot::Situation.new
      (topic.rails_context("Hi mom") {}).local_run(Riot::SilentReporter.new, situation)
      situation
    end

    asserts("situation.topic") { topic.topic }.nil
  end # with description as a string

  context "defined from the root" do
    setup do
      Class.new do
        def self.defined_contexts; @contexts ||= []; end
        def self.context(description, context_class, &definition)
          (defined_contexts << context_class.new(description, &definition)).last
        end
        extend RiotRails::Root
      end
    end

    hookup { topic.rails_context(Object) {} }

    asserts(:defined_contexts).size(1)
    asserts("context type") { topic.defined_contexts.first }.kind_of(RiotRails::RailsContext)
  end # defined from the root

end # The rails_context macro
