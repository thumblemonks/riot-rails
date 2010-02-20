module RiotRails
  register_context_helper do
    def prepare_context(context)
      context.premium_setup { context.description.new } if active_record_context?(context)

      context.transaction do |&original_block|
        ::ActiveRecord::Base.transaction do
          original_block.call
          raise ::ActiveRecord::Rollback
        end
      end
    end
  private
    def active_record_context?(context)
      description = context.description
      description.kind_of?(Class) && description.ancestors.include?(::ActiveRecord::Base)
    end
  end
end # RiotRails
