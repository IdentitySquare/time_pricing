module TimePricing
  module WithCombos

    def best_price_with_combos(duration)
      return 0 if duration <= 0

      cache_key = duration.to_s.to_sym
      if @cache[cache_key]
        return @cache[cache_key]
      end

      charges = []

      @plans.each do |_key, plan|
        remainder = duration - plan[:duration]
        charges << plan[:cost] + best_price_with_combos(remainder)
      end

      @cache[cache_key] = charges.min
    end

  end
end