module RiotRails
  def self.railsify_context(description, &block)
    new_ctx = yield
    new_ctx.setup { description.new }
    new_ctx
  end

  module TopLevel
    def rails_context(description, context_class=Context, &definition)
      RiotRails.railsify_context(description) do
        context(description.to_s, context_class, &definition)
      end
    end
  end # Base

  module Context
    def rails_context(description, &definition)
      RiotRails.railsify_context(description) do
        context(description.to_s, &definition)
      end
    end
  end # Context
end # RiotRails

Riot.extend(RiotRails::TopLevel)
Riot::Context.instance_eval { include RiotRails::Context }
