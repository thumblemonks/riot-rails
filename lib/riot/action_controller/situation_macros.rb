module RiotRails #:nodoc:
  module ActionController #:nodoc:

    module SituationMacros
      attr_reader :controller, :request, :response
    end # SituationMacros

  end # ActionController
end # RiotRails

Riot::Situation.instance_eval do
  include ActionController::TestProcess
  include RiotRails::ActionController::SituationMacros
end
