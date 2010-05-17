require 'teststrap'

context "ActionController middleware" do
  setup_test_context

  helper(:assigned) { |var| topic.instance_variable_get(var) }

  setup do
    situation = Riot::Situation.new
    topic.context(RoomsController) {}.local_run(Riot::SilentReporter.new, situation)
    situation
  end

  asserts(:topic).equals(RoomsController)

  asserts("@app") { assigned(:@app) }.equals(RoomsController)
  asserts("helper app") { topic.app }.equals { assigned(:@app) }

  asserts("@env") { assigned(:@env) }.equals({"rack.session" => {}})
  asserts("helper env") { topic.env }.equals { assigned(:@env) }

  asserts("@controller") { assigned(:@controller) }.kind_of(RoomsController)
  asserts("helper controller") { topic.controller }.equals { assigned(:@controller) }

  asserts("@request") { assigned(:@request) }.kind_of(Rack::Request)
  asserts("helper request") { topic.request }.equals { assigned(:@request) }

  asserts("@response") { assigned(:@response) }.kind_of(Rack::Response)
  asserts("helper response") { topic.response }.equals { assigned(:@response) }

  asserts_topic.responds_to(:get)
  asserts_topic.responds_to(:post)
  asserts_topic.responds_to(:put)
  asserts_topic.responds_to(:delete)

end # ActionController middleware
