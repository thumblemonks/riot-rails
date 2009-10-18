module Riot
  module ActiveRecord

    module AssertionMacros

      # An ActiveRecord assertion that expects to fail when a given attribute is validated after a nil value
      # is provided to it.
      #
      # Example
      #    context "a User" do
      #      setup { User.new }
      #      topic.validates_presence_of(:name)
      #    end
      def validates_presence_of(attribute)
        msg = "expected to validate presence of #{attribute.inspect}"
        error_from_writing_value(actual, attribute, nil) || fail(msg)
      end

      # An ActiveRecord assertion that expects to pass with a given value or set of values for a given
      # attribute.
      #
      # Example
      #    context "a User" do
      #      setup { User.new }
      #      topic.allows_values_for :email, "a@b.cd"
      #      topic.allows_values_for :email, "a@b.cd", "e@f.gh"
      #    end
      def allows_values_for(attribute, *values)
        bad_values = []
        values.each do |value|
          bad_values << value if error_from_writing_value(actual, attribute, value)
        end
        msg = "expected #{attribute.inspect} to allow value(s) #{bad_values.inspect}"
        fail(msg) unless bad_values.empty?
      end

      # An ActiveRecord assertion that expects to fail with a given value or set of values for a given
      # attribute.
      #
      # Example
      #    context "a User" do
      #      setup { User.new }
      #      topic.does_not_allow_values_for :email, "a"
      #      topic.does_not_allow_values_for :email, "a@b", "e f@g.h"
      #    end
      def does_not_allow_values_for(attribute, *values)
        good_values = []
        values.each do |value|
          good_values << value unless error_from_writing_value(actual, attribute, value)
        end
        msg = "expected #{attribute.inspect} not to allow value(s) #{good_values.inspect}"
        fail(msg) unless good_values.empty?
      end

    private

      def error_from_writing_value(model, attribute, value)
        model.write_attribute(attribute, value)
        model.valid?
        model.errors.on(attribute)
      end

    end # AssertionMacros

  end # ActiveRecord
end # Riot

Riot::Assertion.instance_eval { include Riot::ActiveRecord::AssertionMacros }
