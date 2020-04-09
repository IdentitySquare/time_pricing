require "test_helper"

class TimePricingTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TimePricing::VERSION
  end

  # --------------------------------------------------
  # Test for adding plans
  # --------------------------------------------------

  def test_add_plan
    @time_pricing = TimePricing.new

    result = @time_pricing.add_plan!({
      name: 'per_hour',
      duration: 2.hour,
      cost: 500
    })

    assert result.is_a?(TimePricing::Plan)
  end

  def test_add_plan_not_uniq_overwrite
    @time_pricing = TimePricing.new

    @time_pricing.add_plan!({
      name: 'per_hour',
      duration: 2.hour,
      cost: 500
    })


    new_plan = @time_pricing.add_plan!({
      name: 'per_hour',
      duration: 3.hour,
      cost: 500
    })

    assert_equal new_plan.duration, @time_pricing.config.plans['per_hour'].duration
  end

  def test_add_plan_validity
    @time_pricing = TimePricing.new

    assert_raises TimePricing::ParameterMissing do
      @time_pricing.add_plan!({
        name: 'per_hour',
        duration: "hour",
        cost: "hello"
      })
    end

  end

  def test_add_two_plans
    @time_pricing = TimePricing.new

    @time_pricing.add_plan!({
      name: 'per_hour',
      duration: 2.hour,
      cost: 500
    })

    result = @time_pricing.add_plan!({
      name: 'three_hour',
      duration: 3.hour,
      cost: 700
    })

    assert_equal result.cost, @time_pricing.config.plans['three_hour'].cost
  end



  private

  def setup_one_plan
    @time_pricing = TimePricing.new

    @time_pricing.add_plan!({
      name: 'per_hour',
      duration: 1.hour,
      cost: 100
    })
  end

  def setup_two_plans(**args)
    @time_pricing = TimePricing.new(args)

    @time_pricing.add_plan!({
      name: 'two_hour',
      duration: 2.hour,
      cost: 200
    })

    @time_pricing.add_plan!({
      name: 'ten_hour',
      duration: 10.hour,
      cost: 600
    })

  end

end
