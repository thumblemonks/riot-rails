module Protest
  module ActiveRecord
    module Macros

      def should_validate_presence_of(*attributes)
        attributes.each do |attribute|
          should("require value for #{attribute}") do
            topic.write_attribute(attribute, nil)
            topic.valid?
            topic.errors.on(attribute)
          end
        end
      end

    end # Macros
  end # ActiveRecord
end # Protest

Protest::Context.instance_eval { include Protest::ActiveRecord::Macros }
