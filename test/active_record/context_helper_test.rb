require 'teststrap'

context "The rails_context macro" do
  setup_test_context

  context "for an ActiveRecord class" do
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
  end # for an ActiveRecord class

end # The rails_context macro
