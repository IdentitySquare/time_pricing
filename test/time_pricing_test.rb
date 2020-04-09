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


  # --------------------------------------------------
  # Test for removing plans
  # --------------------------------------------------

  def test_delete_one
    setup_one_plan
    result = @time_pricing.remove_plan!("per_hour")

    assert result.name == 'per_hour'
  end

  def test_delete_non_existing_plan
    setup_one_plan
    result = @time_pricing.remove_plan!("annajoe")
    assert result == nil
  end

  # --------------------------------------------------
    # Test for one plan
    # --------------------------------------------------

    [
      [1.hour, 100],
      [6.hours, 600]
    ].each do |test_case|

      define_method("test_one_plan_#{test_case[0]}_with_for_duration") do
        setup_one_plan

        result = @time_pricing.for_duration(test_case[0]).cost
        assert_equal test_case[1], result
      end

      define_method("test_one_plan_#{test_case[0]}_with_for_time") do
        setup_one_plan

        result = @time_pricing.for_time(Time.now, Time.now + test_case[0]).cost
        assert_equal test_case[1], result
      end

    end

  # --------------------------------------------------
  # Test for two plans - combine_plans: true
  # --------------------------------------------------

  [
    [0, 0],
    [1.hour, 200],
    [3.hours, 400],
    [8.hours, 600],
    [12.hours, 800],
    [24.hours, 1600],
    [48.hours, 3000],
    [43.hours, 2800]
  ].each do |test_case|
    define_method("test_two_plans_#{test_case[0]}_with_for_duration") do
      setup_two_plans
      result = @time_pricing.for_duration(test_case[0]).cost
      assert_equal test_case[1], result
    end

    define_method("test_two_plans_#{test_case[0]}_with_for_time") do
      setup_two_plans

      result = @time_pricing.for_time(Time.now, Time.now + test_case[0]).cost
      assert_equal test_case[1], result
    end

  end

  # --------------------------------------------------
  # Test for 2 plans - combine_plans: false
  # --------------------------------------------------

  [
    [0, 0],
    [1.hour, 200],
    [3.hours, 400],
    [8.hours, 600],
    [12.hours, 1200],
    [24.hours, 1800],
    [48.hours, 3000],
    [43.hours, 3000]
  ].each do |test_case|
    define_method("test_combine_plans_false_#{test_case[0]}_with_for_duration") do
      setup_two_plans({combine_plans: false})

      result = @time_pricing.for_duration(test_case[0]).cost
      assert_equal test_case[1], result
    end

    define_method("test_combine_plans_false_#{test_case[0]}_with_for_time") do
      setup_two_plans({combine_plans: false})

      result = @time_pricing.for_time(Time.now, Time.now + test_case[0]).cost
      assert_equal test_case[1], result
    end

  end

  # --------------------------------------------------
  # Test for 5 plans - combine_plans: true
  # --------------------------------------------------
  [
    [0, 0],
    [1.hour, 200],
    [3.hours, 250],
    [8.hours, 700],
    [12.hours, 950],
    [24.hours, 1900],
    [48.hours, 3800],
    [43.hours, 3450]
  ].each do |test_case|
    define_method("test_five_plans_#{test_case[0]}_with_for_duration") do
      setup_five_plans
      result = @time_pricing.for_duration(test_case[0]).cost
      assert_equal test_case[1], result
    end

    define_method("test_five_plans_#{test_case[0]}_with_for_time") do
      setup_five_plans

      result = @time_pricing.for_time(Time.now, Time.now + test_case[0]).cost
      assert_equal test_case[1], result
    end

  end

  # --------------------------------------------------
  # Test for 5 plans - combine_plans: false
  # --------------------------------------------------

  [
    [0, 0],
    [1.hour, 200],
    [3.hours, 250],
    [8.hours, 750],
    [12.hours, 950],
    [24.hours, 1900],
    [48.hours, 3800],
    [43.hours, 3750]
  ].each do |test_case|
    define_method("test_five_plans_no_combo_#{test_case[0]}_with_for_duration") do
      setup_five_plans(combine_plans: false)
      result = @time_pricing.for_duration(test_case[0]).cost
      assert_equal test_case[1], result
    end

    define_method("test_five_plans_no_combo_#{test_case[0]}_with_for_time") do
      setup_five_plans(combine_plans: false)

      result = @time_pricing.for_time(Time.now, Time.now + test_case[0]).cost
      assert_equal test_case[1], result
    end

  end

  # --------------------------------------------------
  # Test for breakdown - 2 plans
  # --------------------------------------------------

  [
    [0, 0],
    [1.hour, 1],
    [3.hours, 2],
    [8.hours, 1],
    [12.hours, 6],
    [24.hours, 3],
    [48.hours, 5],
    [43.hours, 5]
  ].each do |test_case|
    define_method("test_breakdown_of_duration_2_plans_#{test_case[0]}_with_for_duration") do
      setup_two_plans({combine_plans: false})

      result = @time_pricing.for_duration(test_case[0]).breakdown.size
      assert_equal test_case[1], result
    end


  end

  # --------------------------------------------------
  # Test for breakdown - 1 plans
  # --------------------------------------------------

  [
    [1.hour, 1],
    [6.hours, 6]
  ].each do |test_case|
    define_method("test_breakdown_of_duration_1plan_#{test_case[0]}_with_for_duration") do
      setup_one_plan

      result = @time_pricing.for_duration(test_case[0]).breakdown.size
      assert_equal test_case[1], result
    end
  end

  # --------------------------------------------------
  # Test for breakdown - 5 plans
  # --------------------------------------------------

  [
    [0, 0],
    [1.hour, 1],
    [3.hours, 1],
    [8.hours, 3],
    [12.hours, 1],
    [24.hours, 2],
    [48.hours, 4],
    [43.hours, 15]
  ].each do |test_case|
    define_method("test_breakdown_of_duration_5plans_#{test_case[0]}_with_for_duration") do
      setup_five_plans({combine_plans: false})

      result = @time_pricing.for_duration(test_case[0]).breakdown.size
      assert_equal test_case[1], result
    end

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

  def setup_five_plans(**args)
    @time_pricing = TimePricing.new(args)

    @time_pricing.add_plan!({
      name: 'two_hour',
      duration: 2.hour,
      cost: 200
    })

    @time_pricing.add_plan!({
      name: 'ten_hour',
      duration: 10.hour,
      cost: 800
    })

    @time_pricing.add_plan!({
      name: 'three_hour',
      duration: 3.hour,
      cost: 250
    })

    @time_pricing.add_plan!({
      name: 'five_hour',
      duration: 5.hour,
      cost: 450
    })

    @time_pricing.add_plan!({
      name: 'twelve_hour',
      duration: 12.hour,
      cost: 950
    })
  end

end