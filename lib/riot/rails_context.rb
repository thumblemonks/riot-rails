module RiotRails
  def self.helpers; @helpers ||= []; end
  def self.register_context_helper(&handler_block)
    helpers << Class.new(&handler_block).new
  end

  def self.railsify_context(description, context)
    helpers.each { |helper| helper.prepare_context(description, context) }
  end

  class RailsContext < Riot::Context

    def initialize(description, parent=nil, &definition)
      @options = {:transactional => false, :transaction_helper => ::ActiveRecord::Base}
      super(description.to_s, parent, &definition)
    end

    # Technically, this is a secret ... but whatever. It's ruby. Basically, just make this setup more
    # important than any of the others.
    # 
    # Yes I can. See ... I just did!
    def premium_setup(&definition)
      @setups.unshift(::Riot::Setup.new(&definition)).first;
    end

    # Returns true if current context or a parent context has the transactional option enabled. To enable,
    # anywhere within a rails_context or a child context thereof, do:
    #
    #   rails_context Foo do
    #     context "sub context" do
    #       set :transactional, true
    #     end
    #   end
    #
    # Transactional support is disabled by default. When enabled, all transactions are rolled back when the
    # context is done executing.
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

    def set(property, value) options[property] = value; end
  private
    attr_reader :options
  end

  module Root
    # Things an Object needs at the root level
    # 
    #   rails_context SomeKindOfClass do
    #   end
    def rails_context(description, &definition)
      context = context(description.to_s, RailsContext, &definition)
      RiotRails.railsify_context(description, context)
      context
    end
  end # Root

  module Context
    # Things a running context needs
    # 
    #   context "Something" do
    #     rails_context SomeKindOfClass do
    #     end
    #   end
    def rails_context(description, &definition)
      context = new_context(description.to_s, RailsContext, &definition)
      RiotRails.railsify_context(description, context)
      context
    end
  end # Context
end # RiotRails

Object.instance_eval { include RiotRails::Root }
Riot::Context.instance_eval { include RiotRails::Context }
