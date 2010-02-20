module RiotRails
  class ActionControllerHandler
    def self.handle?(description)
      description.kind_of?(Class) && description.ancestors.include?(::ActionController::Base)
    end

    def self.prepare_context(description, context)
      context.controlling(description)
    end
  end # ActionControllerHandler

  register_handler ActionControllerHandler
end # RiotRails
