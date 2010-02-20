module RiotRails
  register_context_helper do
    def prepare_context(description, context)
      context.premium_setup { description.new } if active_record_context?(description)

      context.transaction do |&original_block|
        ::ActiveRecord::Base.transaction do
          original_block.call
          raise ::ActiveRecord::Rollback
        end
      end
    end
  private
    def active_record_context?(description)
      description.kind_of?(Class) && description.ancestors.include?(::ActiveRecord::Base)
    end
  end
end # RiotRails
