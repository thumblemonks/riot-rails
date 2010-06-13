require 'teststrap'

context "Transactional middleware" do
  hookup do
    ActiveRecord::Base.instance_eval do
      # Hijacking transaction and just letting stuff fall through
      def transaction(&block) yield; end
    end
  end

  context "when :transactional is set to true" do
    setup { Riot::Context.new("Room") { set(:transactional, true) } }
  
    asserts("executing context") do
      topic.local_run(Riot::SilentReporter.new, Riot::Situation.new)
    end.raises(ActiveRecord::Rollback)
  end # when :transactional is set to true

  context "when :transactional is not set to true" do
    setup { Riot::Context.new("Room") {} }
  
    asserts("executing context does not raise errors") do
      topic.local_run(Riot::SilentReporter.new, Riot::Situation.new)
    end.exists
  end # when :transactional is not set
  
end # Transactional middleware
