module Protest
  module ActiveRecord
    module Macros
      # An ActiveRecord assertion that expects to fail when a given attribute or attributes are validated
      # with no value provided to them.
      #
      # Example
      #    should_validate_presence_of :name
      #    should_validate_presence_of :name, :email
      def should_validate_presence_of(*attributes)
        attributes.each do |attribute|
          should("require value for #{attribute}") { get_error_from_recording_value(attribute, nil) }
        end
      end

      # An ActiveRecord assertion that expects to pass with a given value or set of values for a given
      # attribute.
      #
      # Example
      #    should_allow_values_for :email, "a@b.cd"
      #    should_allow_values_for :email, "a@b.cd", "e@f.gh"
      def should_allow_values_for(attribute, *values)
        values.each do |value|
          should("allow value of \"#{value}\" for #{attribute}") do
            get_error_from_recording_value(attribute, value).nil?
          end
        end
      end

      # An ActiveRecord assertion that expects to fail with a given value or set of values for a given
      # attribute.
      #
      # Example
      #    should_not_allow_values_for :email, "a"
      #    should_not_allow_values_for :email, "a", "foo.bar"
      def should_not_allow_values_for(attribute, *values)
        values.each do |value|
          should("allow value of \"#{value}\" for #{attribute}") do
            get_error_from_recording_value(attribute, value)
          end
        end
      end
    end # Macros
  end # ActiveRecord

  module Helpers
    module Situation
    private
      def get_error_from_recording_value(attribute, value)
        topic.write_attribute(attribute, value)
        topic.valid?
        topic.errors.on(attribute)
      end
    end # Situation
  end # Helpers
end # Protest

Protest::Context.instance_eval { include Protest::ActiveRecord::Macros }
Protest::Situation.instance_eval { include Protest::Helpers::Situation }
