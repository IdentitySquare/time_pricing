module TimePricing
  class Plan
    attr_reader :name, :duration, :cost

    def initialize(**args)
      @name = args[:name]
      @duration = args[:duration]
      @cost = args[:cost]

      # validate plan data
      if !@name || !@duration.is_a?(Integer) || !@cost.is_a?(Integer)
        raise TimePricing::ParameterMissing.new "Not a valid plan"
      end
    end

    def to_json
      {
        name: @name,
        duration: @duration,
        cost: @cost
      }
    end

  end
end