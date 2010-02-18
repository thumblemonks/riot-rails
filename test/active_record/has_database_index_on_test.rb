require 'teststrap'
require 'ostruct'

context "The has_database_index_on macro" do
  setup_test_context
  setup { topic.asserts("room") { Room.new } }

  hookup do
    MockConnection = Class.new do
      def initialize(index_lookup) @index_lookup = index_lookup; end
      def indexes(table) @index_lookup[table]; end
    end

    def build_assertion(table, columns, unique=false)
      database_connection = MockConnection.new({table => [ define_index(table, columns, unique) ]})
      # I'll inject your dependency! ;)
      RiotRails::ActiveRecord::HasDatabaseIndexOnMacro.new(database_connection)
    end

    def define_index(table, columns, unique)
      ActiveRecord::ConnectionAdapters::IndexDefinition.new(table, columns.join(','), unique, columns)
    end
  end

  should("fail when no index for column") do
    topic.has_database_index_on(:foo).run(Riot::Situation.new)
  end.equals([:fail, %Q{expected index on [:foo]}, blah, blah])

  should("fail when no index for column set") do
    topic.has_database_index_on(:foo, :bar).run(Riot::Situation.new)
  end.equals([:fail, %Q{expected index on [:foo, :bar]}, blah, blah])

  should("fail when index found for column, but it's not unique") do
    build_assertion("rooms", ["foo"], false).
      evaluate(Room.new, :foo, :unique => true)
  end.equals([:fail, %Q{expected unique index on [:foo]}, blah, blah])

  should("fail when index found for column, but it's unique and should not be") do
    build_assertion("rooms", ["foo"], true).
      evaluate(Room.new, :foo, :unique => false)
  end.equals([:fail, %Q{expected index on [:foo]}, blah, blah])

  should("pass when index found for column") do
    build_assertion("rooms", ["foo"], false).
      evaluate(Room.new, :foo)
  end.equals([:pass, %Q{has index on [:foo]}])

  should("pass when index found for column set") do
    build_assertion("rooms", ["foo", "bar"], false).
      evaluate(Room.new, :foo, :bar)
  end.equals([:pass, %Q{has index on [:foo, :bar]}])

  should("pass when unique index found for column") do
    build_assertion("rooms", ["foo"], true).
      evaluate(Room.new, :foo, :unique => true)
  end.equals([:pass, %Q{has unique index on [:foo]}])

  should("pass when unique index found for column set") do
    build_assertion("rooms", ["foo", "bar"], true).
      evaluate(Room.new, :foo, :bar, :unique => true)
  end.equals([:pass, %Q{has unique index on [:foo, :bar]}])

  should("pass when non-unique index found for column") do
    build_assertion("rooms", ["foo"], false).
      evaluate(Room.new, :foo, :unique => false)
  end.equals([:pass, %Q{has index on [:foo]}])

  should("pass when non-unique index found for column set") do
    build_assertion("rooms", ["foo", "bar"], false).
      evaluate(Room.new, :foo, :bar, :unique => false)
  end.equals([:pass, %Q{has index on [:foo, :bar]}])

end # The attribute_is_invalid macro
