module RiotRails
  register_context_helper do
    def prepare_context(context)
      context.controlling(context.description) if action_controller_context?(context)
    end
  private
    def action_controller_context?(context)
      description = context.description
      description.kind_of?(Class) && description.ancestors.include?(::ActionController::Base)
    end
  end
end # RiotRails
