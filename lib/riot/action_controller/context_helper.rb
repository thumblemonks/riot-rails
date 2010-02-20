module RiotRails
  register_context_helper do
    def prepare_context(description, context)
      context.controlling(description) if can_help?(description)
    end
  private
    def can_help?(description)
      description.kind_of?(Class) && description.ancestors.include?(::ActionController::Base)
    end
  end
end # RiotRails
