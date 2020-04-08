module TimePricing
  class Utils
    class << self

      def plan_structure(amount, breakdown=[])
        {
          amount: amount,
          pricing_breakdown: breakdown
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