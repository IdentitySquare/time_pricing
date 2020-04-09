module TimePricing
  class Utils
    class << self

      def cost_struct(cost, plans_used=[])
        {
          cost: cost,
          plans_used: plans_used
        }
      end

      def add_hash(a, b)
        result = {}
        a.each do |key, value|
          result[key] = a[key] + b[key]
        end
        result
      end

    end
  end
end