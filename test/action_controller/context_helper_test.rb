require 'teststrap'

context "The rails_context macro" do
  setup_test_context

  helper(:assigned) { |var| topic.instance_variable_get(var) }

  context "for an ActionController class" do
    setup do
      situation = Riot::Situation.new
      topic.rails_context(RoomsController) {}.local_run(Riot::SilentReporter.new, situation)
      situation
    end
  
    asserts(:topic).equals(RoomsController)
    asserts("@app") { assigned(:@app) }.equals(RoomsController)
    asserts("@env") { assigned(:@env) }.equals({"rack.session" => {}})
    asserts("@controller") { assigned(:@controller) }.kind_of(RoomsController)
    asserts("@request") { assigned(:@request) }.kind_of(Rack::Request)
    asserts("@response") { assigned(:@response) }.kind_of(Rack::Response)
  end # for an ActionController class

end # The rails_context macro
