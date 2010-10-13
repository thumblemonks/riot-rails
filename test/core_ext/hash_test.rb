require 'teststrap'

context "Hash#stringify_values" do
  
  context "a simple hash" do
    setup { { :a => 1} }
    asserts(:stringify_values).equals { {:a => '1'} }
  end
  
  context "a nested hash" do
    setup { { :a => { :b => :ddjkgdkj, :c => 23 }} }
    asserts(:stringify_values).equals { {:a => { :b => 'ddjkgdkj', :c => '23' } } }
  end
  
end

context "Hash#stringify_values!" do
  context "some hash" do
    setup { { 1 => 2 } }
    should "replace self with stringify_values'd version" do
      topic.tap { |t| t.stringify_values! }
    end.equals({ 1 => '2' })
  end
end