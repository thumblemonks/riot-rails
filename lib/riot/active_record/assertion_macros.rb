module RiotRails
  module ActiveRecord

  protected
    class AssertionMacro < ::Riot::AssertionMacro
    private
      def error_from_writing_value(model, attribute, value)
        model.write_attribute(attribute, value)
        model.valid?
        model.errors.on(attribute)
      end
    end

  end # ActiveRecord
end # RiotRails

require 'riot/active_record/validation_macros'
require 'riot/active_record/reflection_macros'
