module Riot
  module ActiveRecord

    module ContextMacros
      # # An ActiveRecord assertion that expects to pass with a given value or set of values for a given
      # # attribute.
      # #
      # # Example
      # #    should_allow_values_for :email, "a@b.cd"
      # #    should_allow_values_for :email, "a@b.cd", "e@f.gh"
      # def should_allow_values_for(attribute, *values)
      #   values.each do |value|
      #     should("allow value of \"#{value}\" for #{attribute}") do
      #       get_error_from_writing_value(topic, attribute, value)
      #     end.nil
      #   end
      # end

      # An ActiveRecord assertion that expects to fail with a given value or set of values for a given
      # attribute.
      #
      # Example
      #    should_not_allow_values_for :email, "a"
      #    should_not_allow_values_for :email, "a", "foo.bar"
      def should_not_allow_values_for(attribute, *values)
        values.each do |value|
          should("allow value of \"#{value}\" for #{attribute}") do
            get_error_from_writing_value(topic, attribute, value)
          end.exists
        end
      end

      # An ActiveRecord assertion that expects to fail with an attribute is not valid for record because the
      # value of the attribute is not unique. Requires the topic of the context to be a created record; one
      # that returns false for a call to +new_record?+.
      #
      # Example
      #    should_validate_uniqueness_of :email
      def should_validate_uniqueness_of(attribute)
        asserts "topic is not a new record when testing uniqueness of #{attribute}" do
          !topic.new_record?
        end

        should "require #{attribute} to be a unique value" do
          copied_model = topic.class.new
          copied_value = topic.read_attribute(attribute)
          get_error_from_writing_value(copied_model, attribute, copied_value)
        end.exists
      end
    end # ContextMacros

  end # ActiveRecord
end # Riot

Riot::Context.instance_eval { include Riot::ActiveRecord::ContextMacros }
