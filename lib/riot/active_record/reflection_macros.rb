require 'ruby-debug'
module RiotRails
  module ActiveRecord
  protected

    class ReflectionAssertionMacro < Riot::AssertionMacro
    private
      def assert_reflection(expected, record, attribute, options)
        options ||= {}
        reflection = record.class.reflect_on_association(attribute)
        if !reflection.nil? && (expected == reflection.macro.to_s)
          options_matched = options.all? do |k, v|
            reflection.options[k] == v
          end

          if options_matched
            pass("#{attribute.inspect} is a #{expected} association")
          else
            options_str = options.map do |k, v|
              "#{k.inspect} => #{v.inspect}"
            end.join(", ")
            fail("should #{expected} #{attribute.inspect} with #{options_str}")
          end
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

      def evaluate(actual, *expectings)
        attribute, options = *expectings
        assert_reflection("has_many", actual, attribute, options)
      end
    end

    # An ActiveRecord assertion macro that expects to pass when a given attribute is defined as a
    # +has_one+ association. Will fail if an association is not defined for the attribute or if the
    # association is not +has_one+.
    #
    #   context "a Room" do
    #     setup { Room.new }
    #
    #     asserts_topic.has_one(:floor)
    #   end
    class HasOneMacro < ReflectionAssertionMacro
      register :has_one

      def evaluate(actual, *expectings)
        attribute, options = *expectings
        assert_reflection("has_one", actual, attribute, options)
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

      def evaluate(actual, *expectings)
        attribute, options = *expectings
        assert_reflection("belongs_to", actual, attribute, options)
      end
    end

    # An ActiveRecord assertion macro that expects to pass when a given attribute is defined as a
    # +has_and_belongs_to_many+ association. Will fail if an association is not defined for the attribute or if the
    # association is not +has_and_belongs_to_many+.
    #
    #   context "a Room" do
    #     setup { Room.new }
    #
    #     asserts_topic.has_and_belongs_to_many(:walls)
    #   end
    class HasAndBelongsToManyMacro < ReflectionAssertionMacro
      register :has_and_belongs_to_many

      def evaluate(actual, *expectings)
        attribute, options = *expectings
        assert_reflection("has_and_belongs_to_many", actual, attribute, options)
      end
    end

  end # ActiveRecord
end # RiotRails
