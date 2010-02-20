module RiotRails
  register_context_helper do
    def can_help?(description)
      description.kind_of?(Class) && description.ancestors.include?(::ActionController::Base)
    end

    def prepare_context(description, context)
      context.controlling(description)
    end
  end
end # RiotRails
