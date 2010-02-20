module RiotRails
  def self.helpers; @helpers ||= []; end
  def self.register_context_helper(&handler_block)
    helpers << Class.new(&handler_block).new
  end

  class RailsContext < Riot::Context
    def initialize(description, parent=nil, &definition)
      @options = {:transactional => false}
      transaction { |&default_block| raise Exception, "No transaction handler" }
      super(description, parent, &definition)
      apply_helpers
    end

    # We're going to allow any helper to help out. Not just one.
    def apply_helpers
      RiotRails.helpers.each { |helper| helper.prepare_context(self) }
    end

    # Set options for the specific rails_context. For instance, you can tell the context to be transactional
    #
    #   rails_context "Foo" do
    #     set :transactional, true
    #   end
    def set(property, value) options[property] = value; end

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

    # TODO: cleanup how we handle transactions and context helpers
    def transaction(&block) @transaction_block = block; end

    def local_run(*args)
      transactional? ? @transaction_block.call { super(*args) } : super
    end
  private
    attr_reader :options
  end

  module Root
    # Things an Object needs at the root level
    # 
    #   rails_context SomeKindOfClass do
    #   end
    def rails_context(description, &definition)
      context(description, RailsContext, &definition)
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
      new_context(description, RailsContext, &definition)
    end
  end # Context
end # RiotRails

Object.instance_eval { include RiotRails::Root }
Riot::Context.instance_eval { include RiotRails::Context }
