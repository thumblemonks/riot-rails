ActiveRecord::Schema.define(:version => 1) do
  create_table :rooms, :force => true do |t|
    t.string :location
    t.string :contents
    t.string :foo
    t.string :bar
  end
end
