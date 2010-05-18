module RiotRails
  class ActiveRecordMiddleware < Riot::ContextMiddleware
    register

    def handle?(context)
      description = context.description
      description.kind_of?(Class) && description.ancestors.include?(::ActiveRecord::Base)
    end

    def call(context)
      context.setup(true) { context.description.new }
    end

  end # ActiveRecordMiddleware
end # RiotRails
