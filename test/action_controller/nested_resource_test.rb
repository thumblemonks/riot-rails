require 'teststrap'

context "GET request for a nested RESTful resource" do
  setup do
    situation = Riot::Situation.new
    context = Riot::Context.new(PartiesController) {}
    context.asserts("stuff") { get("/gremlins/1/parties/2") }
    context.local_run(Riot::SilentReporter.new, situation)
    situation
  end
  
  asserts("parameters inferred from the URL") do
    topic.request.params
  end.equals({ "controller" => "parties", "action" => "show", "gremlin_id" => "1", "id" => "2" })

end
