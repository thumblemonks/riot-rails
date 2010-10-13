module RiotRails
  module CoreExt
    module Hash
      def stringify_values
        inject({}) do |hsh,(key,val)|
          hsh[key] = val.respond_to?(:stringify_values) ? val.stringify_values : val.to_s
          hsh
        end
      end
      
      def stringify_values!
        replace(stringify_values)
      end
    end # Hash
  end # CoreExt
end # RiotRails

Hash.class_eval { include RiotRails::CoreExt::Hash }