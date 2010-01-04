module RiotRails
  module ActiveRecord

    # An ActiveRecord assertion macro that looks for an index on a given set of attributes in the table
    # used by the model under test (aka: topic).
    #
    #   asserts_topic.has_database_index_on :name
    #   asserts_topic.has_database_index_on :email, :group_name
    #
    # In the form used above, the assertion will pass if any index is found with the attributes listed
    # (unique or not). To be specific about uniqueness, provide the +:unique+ option.
    #
    #   asserts_topic.has_database_index_on :email, :unique => true
    #   asserts_topic.has_database_index_on :name, :unique => false
    #
    # The last example will require that the index not be a unique one.
    class HasDatabaseIndexOnMacro < Riot::AssertionMacro
      register :has_database_index_on

      def initialize(database_connection=nil) # Good for testing :)
        @database_connection = database_connection
      end

      def evaluate(actual, *attributes_and_options)
        attributes, options = extract_options_from(attributes_and_options)
        unique = options[:unique]

        index = find_index(actual, attributes, unique)

        static_message = "#{unique ? "unique" : ""} index on #{attributes.inspect}".strip
        index.nil? ? fail("expected #{static_message}") : pass("has #{static_message}")
      end
    private
      def database_connection; @database_connection || ::ActiveRecord::Base.connection; end

      def find_index(model, attributes, uniqueness, &block)
        database_connection.indexes(model.class.table_name).find do |the_index|
          unique_enough?(uniqueness, the_index) && attributes_match?(attributes, the_index)
        end
      end

      def unique_enough?(uniqueness, index)
        return true if uniqueness.nil?
        index.unique == uniqueness
      end

      def attributes_match?(attributes, index)
        Set.new(attributes.map(&:to_s)) == Set.new(index.columns)
      end

      def extract_options_from(attributes)
        options = attributes.last.kind_of?(Hash) ? attributes.pop : {}
        [attributes, options]
      end
    end

  end # ActiveRecord
end # RiotRails
