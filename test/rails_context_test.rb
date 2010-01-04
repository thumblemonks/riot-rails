require 'teststrap'

context "The basic RailsContext " do
  setup do
    RiotRails::RailsContext.new("Room") { }
  end

  asserts_topic.kind_of(Riot::Context)
  asserts(:transactional?).not!
  asserts(:transaction_helper).equals(::ActiveRecord::Base)
end # The basic RailsContext

context "The transactional RailsContext" do
  setup do
    helper = Class.new { def self.transaction(&block) yield; end }
    RiotRails::RailsContext.new("Room") do
      set :transactional, true
      set :transaction_helper, helper
    end
  end

  asserts(:transactional?)

  asserts("calling local run") do
    topic.local_run(Riot::SilentReporter.new, Riot::Situation.new)
  end.raises(::ActiveRecord::Rollback)

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

  asserts("a new Riot::Context") do
    Riot::Context.new("foo") {}
  end.respond_to(:rails_context)

  asserts("its description") do
    Riot::Context.new("foo") {}.rails_context(Room) {}.description
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

  context "for an ActiveRecord object" do
    setup do
      situation = Riot::Situation.new
      topic.rails_context(Room) do
        hookup { topic.email = "i.am@chee.se" }
      end.local_run(Riot::SilentReporter.new, situation)
      situation.topic
    end
  
    asserts_topic.kind_of(Room)
    asserts(:new_record?)
    asserts(:email).equals("i.am@chee.se")
  end # for an ActiveRecord object

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

    hookup { topic.rails_context(Room) {} }

    asserts(:defined_contexts).size(1)
    asserts("context type") { topic.defined_contexts.first }.kind_of(RiotRails::RailsContext)
  end # defined from the root

end # The rails_context macro
