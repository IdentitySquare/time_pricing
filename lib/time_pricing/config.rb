module TimePricing
  class Config
    attr_accessor :combine_plans, :plans, :cache

    def initialize(**args)
      @combine_plans = args[:combine_plans] || args[:combine_plans] == nil

      @plans = {}

      if args[:cache].is_a?(Hash)
        @cache = args[:cache]
      else
        @cache = {}
      end
    end

    def clear_cache!
      @cache = {}
    end

    def add_plan!(**args)
      plan = Plan.new(args)

      # clear cache as plans change
      clear_cache!

      @plans[plan.name] = plan
    end

    def remove_plan!(name)
      # clear cache as plans change
      clear_cache!
      @plans.delete(name)
    end

    def combine_plans?
      @combine_plans
    end

  end
end