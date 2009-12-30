module RiotRails
  module ActiveRecord

  protected

    class ReflectionAssertionMacro < AssertionMacro
    private
      def assert_reflection(expected, record, attribute)
        reflection = record.class.reflect_on_association(attribute)
        if !reflection.nil? && (expected == reflection.macro.to_s)
          pass("#{attribute.inspect} is a #{expected} association")
        else
          fail("#{attribute.inspect} is not a #{expected} association")
        end
      end
    end

  public

    # An ActiveRecord assertion macro that expects to pass when a given attribute is defined as a +has_many+
    # association. Will fail if an association is not defined for the attribute or if the association is
    # not +has_many+.
    #
    #   context "a Room" do
    #     setup { Room.new }
    #
    #     asserts_topic.has_many(:doors)
    #     asserts_topic.has_many(:floors) # should probably fail given our current universe :)
    #   end
    class HasManyMacro < ReflectionAssertionMacro
      register :has_many
      
      def evaluate(actual, attribute)
        assert_reflection("has_many", actual, attribute)
      end
    end

    # An ActiveRecord assertion macro that expects to pass when a given attribute is defined as a 
    # +belongs_to+ association. Will fail if an association is not defined for the attribute or if the
    # association is not +belongs_to+.
    #
    #   context "a Room" do
    #     setup { Room.new }
    #
    #     asserts_topic.belongs_to(:house)
    #   end
    class BelongsToMacro < ReflectionAssertionMacro
      register :belongs_to
      
      def evaluate(actual, attribute)
        assert_reflection("belongs_to", actual, attribute)
      end
    end

  end # ActiveRecord
end # RiotRails