module RiotRails
  class ActiveRecordMiddleware < Riot::ContextMiddleware
    register

    def call(context)
      if handle?(context)
        context.setup(true) { context.description.new }
      end
      middleware.call(context)
    end
  private
    def handle?(context)
      description = context.description
      description.kind_of?(Class) && description.ancestors.include?(::ActiveRecord::Base)
    end
  end # ActiveRecordMiddleware
end # RiotRails
