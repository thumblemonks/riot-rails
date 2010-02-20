module RiotRails
  class ActiveRecordHandler
    def self.handle?(description)
      description.kind_of?(Class) && description.ancestors.include?(::ActiveRecord::Base)
    end

    def self.prepare_context(description, context)
      context.premium_setup { description.new }
    end
  end # ActiveRecordHandler
  
  register_handler ActiveRecordHandler
end # RiotRails
