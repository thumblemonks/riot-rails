module RiotRails
  
  class RailsContext < Riot::Context
    def initialize(description, *parent_and_options, &definition)
      parent, options = extract_parent_and_options(parent_and_options)
      setup_options(parent, options)
      super(description, parent, &definition)
    end

    def transactional?
      options[:transactional] || (parent.respond_to?(:transactional?) && parent.transactional?)
    end

    def transaction_helper
      options[:transaction_helper]
    end

    def local_run(*args)
      return super unless transactional?
      transaction_helper.transaction do
        super
        raise ::ActiveRecord::Rollback
      end
    end
  private
    attr_reader :options

    def extract_parent_and_options(args)
      options = args.last.kind_of?(Hash) ? args.pop : {}
      [args.shift, options]
    end
    
    def setup_options(parent, provided)
      defaults = {:transactional => false, :transaction_helper => ::ActiveRecord::Base}
      @options = defaults.merge(provided)
    end
  end

  def self.railsify_context(description, &block)
    new_ctx = yield
    new_ctx.setup { description.new }
    new_ctx
  end

  # Things an Object needs at the root level
  # 
  #   rails_context SomeKindOfClass do
  #   end
  module Root
    def rails_context(description, context_class=Riot::Context, &definition)
      RiotRails.railsify_context(description) do
        context(description.to_s, context_class, &definition)
      end
    end
  end # Base

  # Things a running context needs
  # 
  #   context "Something" do
  #     rails_context SomeKindOfClass do
  #     end
  #   end
  module Context
    def rails_context(description, &definition)
      RiotRails.railsify_context(description) do
        context(description.to_s, &definition)
      end
    end
  end # Context
end # RiotRails

Object.instance_eval { include RiotRails::Root }
Riot::Context.instance_eval { include RiotRails::Context }
