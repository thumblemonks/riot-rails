module Riot
  module ActiveRecord

    module SituationMacros
    private
      def get_error_from_writing_value(model, attribute, value)
        model.write_attribute(attribute, value)
        model.valid?
        model.errors.on(attribute)
      end
    end # SituationMacros

  end # ActiveRecord
end # Riot

Riot::Situation.instance_eval { include Riot::ActiveRecord::SituationMacros }
