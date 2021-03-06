module TimePricing
  class Calculation
    attr_reader :config, :start_time, :end_time, :duration, :cost, :plans_used

    def initialize(config)
      @config = config
      @start_time = nil
    end

    def for_time(start_time, end_time)
      @start_time = start_time
      @end_time = end_time

      # find duration from start_time & end_time
      duration = (end_time - start_time).to_i
      for_duration(duration)
    end

    def for_duration(duration)
      @duration = duration

      if @config.combine_plans?
        result = best_cost_with_combos(duration)
      else
        result = best_cost_without_combos(duration)
      end

      @cost = result[:cost]
      @plans_used = result[:plans_used]

      self
    end

    def breakdown
      result = []
      current_start_time = @start_time

      @plans_used.each do |plan_name|
        plan = @config.plans[plan_name]
        plan_json = plan.to_json

        if @start_time
          end_time = @start_time + plan.duration

          plan_json.merge!({
            start_time: current_start_time,
            end_time: end_time
          })

          current_start_time = end_time + 1
        end

        result << plan_json
      end

      result
    end

    def total_duration
      duration = 0

      @plans_used.each do |plan_name|
        plan = @config.plans[plan_name]
        duration += plan.duration
      end

      duration
    end

    def extra_duration
      total_duration - @duration
    end

    private

    def best_cost_without_combos(duration)
      costs = []

      @config.plans.each do |key, plan|
        costs << cost_for_plan(plan, duration)
      end

      # puts costs
      costs.min_by{|n| n[:cost] }
    end


    def cost_for_plan(plan, duration)
      return Utils.cost_struct(0) if duration <= 0

      Utils.add_hash(
        Utils.cost_struct(plan.cost, [plan.name]),
        cost_for_plan(plan, duration - plan.duration)
      )
    end


    def best_cost_with_combos(duration)
      return Utils.cost_struct(0) if duration <= 0

      cache_key = duration.to_s.to_sym
      if @config.cache[cache_key]
        return @config.cache[cache_key]
      end

      charges = []

      @config.plans.each do |_key, plan|
        current_plan = Utils.cost_struct(plan.cost, [plan.name])
        remainder = best_cost_with_combos(duration - plan.duration)
        charges << Utils.add_hash(current_plan, remainder)
      end

      @config.cache[cache_key] = charges.min_by{|n| n[:cost] }
    end

  end
end