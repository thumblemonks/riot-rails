module RiotRails
  class ActiveRecordMiddleware < Riot::ContextMiddleware
    register

    def handle?(context)
      description = context.description
      description.kind_of?(Class) && description.ancestors.include?(::ActiveRecord::Base)
    end

    def call(context)
      context.setup(true) { context.description.new }

      # context.transaction do |&original_block|
      #   ::ActiveRecord::Base.transaction do
      #     original_block.call
      #     raise ::ActiveRecord::Rollback
      #   end
      # end
    end

  end # ActiveRecordMiddleware
end # RiotRails
