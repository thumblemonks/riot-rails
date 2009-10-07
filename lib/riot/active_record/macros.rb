module Riot
  module ActiveRecord
    module Macros
      # An ActiveRecord assertion that expects to fail when a given attribute or attributes are validated
      # when a nil value is provided to them.
      #
      # Example
      #    should_validate_presence_of :name
      #    should_validate_presence_of :name, :email
      def should_validate_presence_of(*attributes)
        attributes.each do |attribute|
          should("require value for #{attribute}") do
            !get_error_from_recording_value(topic, attribute, nil).nil?
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
            get_error_from_recording_value(topic, attribute, value).nil?
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
            !get_error_from_recording_value(topic, attribute, value).nil?
          end
        end
      end

      # An ActiveRecord assertion that expects to fail with an attribute is not valid for record because the
      # value of the attribute is not unique. Requires the topic of the context to be a created record; one
      # that returns false for a call to +new_record?+.
      #
      # Example
      #    should_validate_uniqueness_of :email
      def should_validate_uniqueness_of(attribute)
        should "require #{attribute} to be a unique value" do
          fail("expected topic not to be a new record") if topic.new_record?
          copied_model = topic.class.new
          copied_value = topic.read_attribute(attribute)
          !get_error_from_recording_value(copied_model, attribute, copied_value).nil?
        end
      end
    end # Macros
  end # ActiveRecord

  module Helpers
    module Situation
    private
      def get_error_from_recording_value(model, attribute, value)
        model.write_attribute(attribute, value)
        model.valid?
        model.errors.on(attribute)
      end
    end # Situation
  end # Helpers
end # Riot

Riot::Context.instance_eval { include Riot::ActiveRecord::Macros }
Riot::Situation.instance_eval { include Riot::Helpers::Situation }
