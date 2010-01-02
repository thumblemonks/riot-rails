module RiotRails
  module ActiveRecord
  protected

    class ValidationAssertionMacro < Riot::AssertionMacro
    private
      def error_from_writing_value(model, attribute, value)
        model.write_attribute(attribute, value)
        model.valid?
        model.errors.on(attribute)
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
          bad_values << value if error_from_writing_value(actual, attribute, value)
        end
        failure_msg = "expected %s to allow value(s) %s"
        bad_values.empty? ? pass : fail(failure_msg % [attribute.inspect, bad_values.inspect])
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
          good_values << value unless error_from_writing_value(actual, attribute, value)
        end
        failure_msg = "expected %s not to allow value(s) %s"
        good_values.empty? ? pass : fail(failure_msg % [attribute.inspect, good_values.inspect])
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
        actual_errors = Array(error_from_writing_value(actual, attribute, value))
        if actual_errors.empty?
          fail("expected #{attribute.inspect} to be invalid when value is #{value.inspect}")
        elsif expected_error && !has_error_message?(expected_error, actual_errors)
          message = "expected %s to be invalid with error message %s"
          fail(message % [attribute.inspect, expected_error.inspect])
        else
          pass("attribute #{attribute.inspect} is invalid")
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
        if error_from_writing_value(actual, attribute, nil)
          pass("validates presence of #{attribute.inspect}")
        else
          fail("expected to validate presence of #{attribute.inspect}")
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
          fail("must use a persisted record when testing uniqueness of #{attribute.inspect}")
        else
          copied_model = actual_record.class.new
          actual_record.attributes.each do |dup_attribute, dup_value|
            copied_model.write_attribute(dup_attribute, dup_value)
          end
          copied_value = actual_record.read_attribute(attribute)
          if error_from_writing_value(copied_model, attribute, copied_value)
            pass("#{attribute.inspect} is unique")
          else
            fail("expected to fail because #{attribute.inspect} is not unique")
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
          errors = error_from_writing_value(actual, attribute, "r" * length)
          return fail("#{attribute.inspect} should be able to be #{length} characters") if errors
        end

        if (min-1) > 0 && error_from_writing_value(actual, attribute, "r" * (min-1)).nil?
          fail("#{attribute.inspect} expected to be more than #{min-1} characters")
        elsif error_from_writing_value(actual, attribute, "r" * (max+1)).nil?
          fail("#{attribute.inspect} expected to be less than #{max+1} characters")
        else
          pass("validates length of #{attribute.inspect} is within #{range.inspect}")
        end
      end
    end

    class AttributeIsInvalidMacro < ValidationAssertionMacro
      register :attribute_is_invalid

      def evaluate(actual, attribute, error_message)
        actual.valid?
        errors = actual.errors.on(attribute)
        if errors.nil?
          fail("#{attribute.inspect} expected to be invalid")
        elsif errors.include?(error_message)
          pass("#{attribute.inspect} is invalid")
        else
          fail("#{attribute.inspect} is invalid, but #{error_message.inspect} is not a valid error message")
        end
      end
    end

  end # ActiveRecord
end # RiotRails
