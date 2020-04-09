module TimePricing
  class Base
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def plans
      @config.plans
    end

    def add_plan!(**args)
      @config.add_plan!(**args)
    end

    def remove_plan!(name)
      @config.remove_plan!(name)
    end

    def combine_plans?
      @config.combine_plans?
    end

    def for_time(start_time, end_time)
      Calculation.new(config).for_time(start_time, end_time)
    end

    def for_duration(duration)
      Calculation.new(config).for_duration(duration)
    end

  end
end