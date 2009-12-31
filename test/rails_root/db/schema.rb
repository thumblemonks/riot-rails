ActiveRecord::Schema.define(:version => 1) do
  create_table :rooms, :force => true do |t|
    t.string :location
    t.string :email
    t.string :contents
    t.string :name
  end
end
