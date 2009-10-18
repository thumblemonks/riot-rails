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
        actual.write_attribute(attribute, nil)
        actual.valid?
        actual.errors.on(attribute) || fail("expected to validate presence of #{attribute}")
        # attributes.each do |attribute|
        #   should("require value for #{attribute}") do
        #     get_error_from_writing_value(topic, attribute, nil)
        #   end.exists
        # end
      end
    end # AssertionMacros

  end # ActiveRecord
end # Riot

Riot::Assertion.instance_eval { include Riot::ActiveRecord::AssertionMacros }
