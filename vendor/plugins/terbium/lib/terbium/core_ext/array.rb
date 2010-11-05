module Terbium
  module CoreExt
    module Array

      # Checks if array includes other +array+
      def include_array? array
        self & array == array
      end

    end
  end
end
