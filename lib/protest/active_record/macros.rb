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
          should("require value for #{attribute}") do
            topic.write_attribute(attribute, nil)
            topic.valid?
            topic.errors.on(attribute)
          end
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
            topic.write_attribute(attribute, value)
            topic.valid?
            topic.errors.on(attribute).nil?
          end
        end
      end

      # An ActiveRecord assertion that expects to fail with a given value or set of values for a given
      # attribute.
      #
      # Example
      #    should_not_allow_values_for :email, "a@b.cd"
      #    should_not_allow_values_for :email, "a@b.cd", "e@f.gh"
      def should_not_allow_values_for(attribute, *values)
        values.each do |value|
          should("allow value of \"#{value}\" for #{attribute}") do
            topic.write_attribute(attribute, value)
            topic.valid?
            topic.errors.on(attribute)
          end
        end
      end

    end # Macros
  end # ActiveRecord
end # Protest

Protest::Context.instance_eval { include Protest::ActiveRecord::Macros }
