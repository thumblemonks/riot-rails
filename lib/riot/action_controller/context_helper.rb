module RiotRails
  register_context_helper do
    def prepare_context(description, context)
      context.controlling(description) if action_controller_context?(description)
    end
  private
    def action_controller_context?(description)
      description.kind_of?(Class) && description.ancestors.include?(::ActionController::Base)
    end
  end
end # RiotRails
