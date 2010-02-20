module RiotRails
  register_context_helper do
    def prepare_context(description, context)
      context.premium_setup { description.new } if can_help?(description)
    end
  private
    def can_help?(description)
      description.kind_of?(Class) && description.ancestors.include?(::ActiveRecord::Base)
    end
  end
end # RiotRails
