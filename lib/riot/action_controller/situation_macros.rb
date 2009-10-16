module Riot #:nodoc:
  module ActionController #:nodoc:

    module SituationMacros
      attr_reader :controller, :request, :response
    end # SituationMacros

  end # ActionController
end # Riot

Riot::Situation.instance_eval do
  include ActionController::TestProcess
  include Riot::ActionController::SituationMacros
end
