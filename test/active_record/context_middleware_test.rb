require 'teststrap'

context "ActiveRecord middleware" do
  setup_test_context

  setup do
    situation = Riot::Situation.new
    topic.context(Room) do
      hookup { topic.email = "i.am@chee.se" }
    end.local_run(Riot::SilentReporter.new, situation)
    situation.topic
  end

  asserts_topic.kind_of(Room)
  asserts(:new_record?)
  asserts(:email).equals("i.am@chee.se")

end # ActiveRecord middleware
