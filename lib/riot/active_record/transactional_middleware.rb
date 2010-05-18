module RiotRails
  class TransactionalMiddleware < Riot::ContextMiddleware
    register
    
    def handle?(context)
      context.option(:transactional) == true
    end

    def call(context)
      context.class.class_eval do
        alias_method :transactionless_local_run, :local_run
        def local_run(*args)
          ::ActiveRecord::Base.transaction do
            transactionless_local_run(*args)
            raise ::ActiveRecord::Rollback
          end
        end
      end
    end
  end
end # RiotRails
