# TimePricing

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/time_pricing`. To experiment with that code, run `bin/console` for an interactive prompt.


Calculate time based pricing based on duration or start + end time. Useful for services, bookings or appointments where pricing is based on duration.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'time_pricing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install time_pricing

## Basic Usage Example

Initialize the service, define available plans and query for price with a time range or duration.

``` ruby
# New pricing calculation
time_pricing = TimePricing.new

# Add available plans

time_pricing.add_plan!({
    name: 'per_hour',
    duration: 1.hour, // duration in milliseconds
    cost: 1000 # €10.00 for an hour
})

time_pricing.add_plan!({
    name: 'per_day',
    duration: 1.day,
    cost: 2000 # €20.00 for 1 day
})

time_pricing.add_plan!({
    name: 'per_week',
    duration: 1.month,
    cost: 100000 # €100.00 for a week
})

# Calculate with time ranges

cost = time_pricing.for_time(Time.now, Time.now + 6.hours).amount

# OR with duration

cost = time_pricing.for_duration(6.hours).amount

puts cost
# => 2000
# (€20.00 because 'per day' rate is cheaper than 6 * 'per hour' rate of €60.00 in total)
```

## Options

### Initializing

``` ruby
TimePricing.new({
    combine_plans: true
})
```
* `combine_plans` *(optional, default `true`)*: Set to `false` to not combine multiple plans to make up the duration. Each plan is only added with itself to make up the duration.

### Adding a plan

``` ruby
time_pricing.add_plan!({
    name: 'per_hour',
    duration: 1.hour,
    cost: 2000
})
```

* `name` *(required)*: a unique identifier for each plan
* `duration` *(required)*: milliseconds of how long is this plan for
* `cost` *(required)*: a positive integer representing how much to charge in the smallest currency unit (e.g., 100 cents to charge $1.00 or 100 to charge ¥100, a zero-decimal currency). Can be set to 0 for a free plan.

### Removing a plan

``` ruby
# remove a plan with it's unique name
time_pricing.remove_plan!('per_day')
```

### Calculating price

``` ruby
time_pricing.for_time({start_time: Time.now, end_time: Time.now + 6.hours}).amount
```

* `start_time` *(required)*: timestamp
* `end_time` *(required)*: timestamp


``` ruby
time_pricing.for_duration({duration: 6.hours}).amount
```

* `duration` *(required)*

### Other methods

``` ruby
# returns true/false as setup
time_pricing.cheapest_price?

# a list of plans that are setup. Returns an array of plan objects
time_pricing.plans
time.pricing.plans.each do |plan|
    puts plan.name
    puts plan.duration
    puts plan.cost
end


pricing_for_duration = time_pricing.for_duration({duration: 6.hours})

# price in cents
pricing_for_duration.amount
# => 2000

# breakdown of how the amount was calculated and what plans were used
pricing_for_duration.pricing_breakdown
# [
#    {
#        start_time: "",
#        end_time: "",
#        duration: 0,
#        name: "per_day",
#        cost: 1000
#    },
#    {
#        start_time: "",
#        end_time: "",
#        duration: 0,
#        name: "per_day",
#        cost: 1000
#    },
#    {...}
# ]

```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/identitysquare/time_pricing. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TimePricing project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/time_pricing/blob/master/CODE_OF_CONDUCT.md).


