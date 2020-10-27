module EtsyApi
  module Element

    module ClassMethods

      def attribute(name, options = {})
        define_method name do
          @result[options.fetch(:from, name).to_s]
        end
      end
      
    end

  end

end
