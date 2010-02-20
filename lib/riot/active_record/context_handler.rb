module RiotRails
  register_context_helper do
    def can_help?(description)
      description.kind_of?(Class) && description.ancestors.include?(::ActiveRecord::Base)
    end

    def prepare_context(description, context)
      context.premium_setup { description.new }
    end
  end
end # RiotRails
