require 'teststrap'

context "ActionController middleware" do
  setup_test_context

  helper(:assigned) { |var| topic.instance_variable_get(var) }

  context "pre-request state" do
    setup do
      situation = Riot::Situation.new
      topic.context(RoomsController) {}.local_run(Riot::SilentReporter.new, situation)
      situation
    end

    asserts(:topic).equals(RoomsController)

    asserts("@app") { assigned(:@app).to_s }.equals { ::Rails.application.to_s }
    asserts("helper app") { topic.app.to_s }.equals { assigned(:@app).to_s }

    asserts("@env") { assigned(:@env) }.equals({})
    asserts("helper env") { topic.env }.equals { assigned(:@env) }

    asserts("helper controller") { topic.controller }.equals { assigned(:@controller) }

    asserts("request before any request made") do
      topic.request
    end.raises(Exception, "No request made yet")

    asserts("response before any request made") do
      topic.response
    end.raises(Exception, "No response since no request made yet")

    asserts_topic.responds_to(:get)
    asserts_topic.responds_to(:post)
    asserts_topic.responds_to(:put)
    asserts_topic.responds_to(:delete)
  end # pre-request state

  context "post-request state" do
    setup do
      situation = Riot::Situation.new
      topic.context(RoomsController) do
        setup { get("/rooms") }
      end.local_run(Riot::SilentReporter.new, situation)
      situation
    end

    asserts(:topic).kind_of(Array)
    asserts(:topic).size(3)
    asserts("#topic first element response status") { topic.topic[0] }.equals(200)
    asserts("#topic second element") { topic.topic[1] }.kind_of(Hash)
    asserts("#topic second element") { topic.topic[1] }.includes("ETag")
    asserts("#topic last element") { topic.topic[2] }.kind_of(ActionDispatch::Response)

    asserts("helper env") { topic.env }.includes("action_controller.instance")

    asserts("helper controller") { topic.controller }.kind_of(RoomsController)
    asserts("env['action_controller.instance']") do
      topic.env["action_controller.instance"]
    end.kind_of(RoomsController)

    asserts("helper request") { topic.request }.kind_of(Rack::Request)
    asserts("helper response") { topic.response }.kind_of(Rack::Response)
  end # post-request state

end # ActionController middleware
