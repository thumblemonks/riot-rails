module RiotRails
  module ActiveRecord
  protected

    class ValidationAssertionMacro < Riot::AssertionMacro
    private
      def errors_from_writing_value(model, attribute, value)
        # TODO: Fix me to not use __send__
        model.__send__(:write_attribute, attribute, value)
        model.valid?
        model.errors[attribute]
      end

      def errors_from_writing_value?(*args)
        errors_from_writing_value(*args).any?
      end
    end

  public

    # An ActiveRecord assertion that expects to pass with a given value or set of values for a given
    # attribute.
    #
    #    rails_context User do
    #      asserts_topic.allows_values_for :email, "a@b.cd"
    #      asserts_topic.allows_values_for :email, "a@b.cd", "e@f.gh"
    #    end
    class AllowsValuesForMacro < ValidationAssertionMacro
      register :allows_values_for

      def evaluate(actual, attribute, *values)
        bad_values = []
        values.each do |value|
          bad_values << value if errors_from_writing_value?(actual, attribute, value)
        end
        bad_values.empty? ? pass : fail(expected_message(attribute).to_allow_values(bad_values))
      end
    end

    # An ActiveRecord assertion that expects to fail with a given value or set of values for a given
    # attribute.
    #
    #    rails_context User do
    #      asserts_topic.does_not_allow_values_for :email, "a"
    #      asserts_topic.does_not_allow_values_for :email, "a@b", "e f@g.h"
    #    end
    class DoesNotAllowValuesForMacro < ValidationAssertionMacro
      register :does_not_allow_values_for
      def evaluate(actual, attribute, *values)
        good_values = []
        values.each do |value|
          good_values << value unless errors_from_writing_value?(actual, attribute, value)
        end
        good_values.empty? ? pass : fail(expected_message(attribute).not_to_allow_values(good_values))
      end
    end

    # An ActiveRecord assertion that expects to fail with invalid value for an attribute. Optionally, the 
    # error message can be provided as the exact string or as regular expression.
    #
    #    rails_context User do
    #      asserts_topic.is_invalid_when :email, "fake", "is invalid"
    #      asserts_topic.is_invalid_when :email, "another fake", /invalid/
    #    end
    class IsInvalidWhenMacro < ValidationAssertionMacro
      register :is_invalid_when

      def evaluate(actual, attribute, value, expected_error=nil)
        actual_errors = errors_from_writing_value(actual, attribute, value)
        if actual_errors.empty?
          fail expected_message(attribute).to_be_invalid_when_value_is(value)
        elsif expected_error && !has_error_message?(expected_error, actual_errors)
          fail expected_message(attribute).to_be_invalid_with_error_message(expected_error)
        else
          pass new_message.attribute(attribute).is_invalid
        end
      end
    private
      def has_error_message?(expected, errors)
        return true unless expected
        expected.kind_of?(Regexp) ? errors.any? {|e| e =~ expected } : errors.any? {|e| e == expected }
      end
    end

    # An ActiveRecord assertion that expects to fail when a given attribute is validated after a nil value
    # is provided to it.
    #
    #    rails_context User do
    #      asserts_topic.validates_presence_of(:name)
    #    end
    class ValidatesPresenceOfMacro < ValidationAssertionMacro
      register :validates_presence_of

      def evaluate(actual, attribute)
        if errors_from_writing_value?(actual, attribute, nil)
          pass new_message.validates_presence_of(attribute)
        else
          fail expected_message.to_validate_presence_of(attribute)
        end
      end
    end

    # An ActiveRecord assertion that expects to fail with an attribute is not valid for record because the
    # value of the attribute is not unique. Requires the topic of the context to be a created record; one
    # that returns false for a call to +new_record?+.
    #
    #    rails_context User do
    #      setup { User.create(:email => "a@b.cde", ... ) }
    #      asserts_topic.validates_uniqueness_of :email
    #    end
    class ValidatesUniquenessOfMacro < ValidationAssertionMacro
      register :validates_uniqueness_of
      
      def evaluate(actual, attribute)
        actual_record = actual
        if actual_record.new_record?
          fail new_message.must_use_a_persisted_record_when_testing_uniqueness_of(attribute)
        else
          copied_model = actual_record.class.new
          actual_record.attributes.each do |dup_attribute, dup_value|
            copied_model.__send__(:write_attribute, dup_attribute, dup_value)
          end
          copied_value = actual_record.__send__(:read_attribute, attribute)
          if errors_from_writing_value?(copied_model, attribute, copied_value)
            pass new_message(attribute).is_unique
          else
            fail expected_message.to_fail_because(attribute).is_not_unique
          end
        end
      end
    end

    # An ActiveRecord assertion to test that the length of the value of an attribute must be within a 
    # specified range. Assertion fails if: there are errors when min/max characters are used, there are no 
    # errors when min-1/max+1 characters are used.
    #
    #    rails_context User do
    #      asserts_topic.validates_length_of :name, (2..36)
    #    end
    #
    # TODO: allow for options on what to validate
    class ValidatesLengthOfMacro < ValidationAssertionMacro
      register :validates_length_of

      def evaluate(actual, attribute, range)
        min, max = range.first, range.last
        [min, max].each do |length|
          if errors_from_writing_value?(actual, attribute, "r" * length)
            return fail(new_message(attribute).should_be_able_to_be(length).characters)
          end
        end

        if (min-1) > 0 && !errors_from_writing_value?(actual, attribute, "r" * (min-1))
          fail new_message(attribute).expected_to_be_more_than(min - 1).characters
        elsif !errors_from_writing_value?(actual, attribute, "r" * (max+1))
          fail new_message(attribute).expected_to_be_less_than(max + 1).characters
        else
          pass new_message.validates_length_of(attribute).is_within(range)
        end
      end
    end

    # An ActiveRecord assertion to test that an attribute is invalid along with the expected error message
    # (or error message partial). The assumption is that a value has already been set.
    #
    #    rails_context User do
    #      hookup { topic.bio = "I'm a goofy clown" }
    #      asserts_topic.attribute_is_invalid :bio, "cannot contain adjectives"
    #    end
    class AttributeIsInvalidMacro < ValidationAssertionMacro
      register :attribute_is_invalid

      def evaluate(actual, attribute, error_message)
        actual.valid?
        errors = actual.errors[attribute]
        if errors.empty?
          fail new_message(attribute).expected_to_be_invalid
        elsif errors.include?(error_message)
          pass new_message(attribute).is_invalid
        else
          fail new_message(attribute).is_invalid.but(error_message).is_not_a_valid_error_message
        end
      end
    end

  end # ActiveRecord
end # RiotRails
