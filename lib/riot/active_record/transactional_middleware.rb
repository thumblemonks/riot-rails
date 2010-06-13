module RiotRails
  class TransactionalMiddleware < Riot::ContextMiddleware
    register
    
    def call(context)
      middleware.call(context)
      hijack_local_run(context) if handle?(context)
    end
  private
    def handle?(context)
      context.option(:transactional) == true
    end

    # Don't you just love mr. metaclass?
    def hijack_local_run(context)
      (class << context; self; end).class_eval do
        alias_method :transactionless_local_run, :local_run
        def local_run(*args)
          ::ActiveRecord::Base.transaction do
            transactionless_local_run(*args)
            raise ::ActiveRecord::Rollback
          end
        end # local_run
      end # metaclass
    end # hijack_local_run

  end # TransactionalMiddleware
end # RiotRails
