# ⏳💰 TimePricing

Calculate time based pricing based on duration or start time + end time. Useful for services, bookings or appointments where pricing is based on duration. This can be used with repeating combination of plans or without combining plans.

## 🛠Installation

Add this line to your application's Gemfile:

```ruby
gem 'time_pricing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install time_pricing

## ✅ Basic Usage Example

Initialize the service, define available plans and query for price with a time range or duration.

``` ruby
# New pricing calculation
time_pricing = TimePricing.new

# Add available plans

time_pricing.add_plan!({
    name: 'per_hour',
    duration: 1.hour, # duration in milliseconds
    cost: 500 # €5.00 for an hour
})

time_pricing.add_plan!({
    name: 'per_day',
    duration: 1.day,
    cost: 2000 # €20.00 for 1 day
})

# Calculate with time ranges

cost = time_pricing.for_time(Time.now, Time.now + 6.hours).cost

# OR with duration

cost = time_pricing.for_duration(6.hours).cost

puts cost
# => 2000
# (€20.00 because 'per day' rate is cheaper than 6 * 'per hour' rate of €60.00 in total)
```

## 🛠 Options

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

### Other methods
``` ruby
# a list of plans that are setup. Returns an array of plan objects
time_pricing.plans
```

### Calculating price

``` ruby
time_pricing.for_time(Time.now, Time.now + 6.hours).cost
```

* `start_time` *(required)*: timestamp
* `end_time` *(required)*: timestamp


``` ruby
time_pricing.for_duration(6.hours).cost
```

* `duration` *(required)*

### Calculation breakdown
How did we get to the final cost.

``` ruby
calculation = time_pricing.for_duration(6.hours)

# price in cents
calculation.cost

# if using the for_time method
calculation.start_time
calculation.end_time

# the requested duration for pricing
calculation.duration

# Total duration (in milliseconds) the plans make up
calculation.total_duration

# any extra duration (in milliseconds) than the requested
# to make up for the requested duration
calculation.extra_duration

# breakdown of how the cost was calculated and what plans were used
calculation.breakdown
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
# start_time and end_time only appears if using for_time to calculate cost

```

## 🏎 Caching the combinations externally

TimePricing uses cache to keep track of pricing that we have calculated already to speed up the going through all the combinations possible if `combine_plan: true`. This significantly speeds up the calculations. This can be saved externally from the gem and can be set for even faster look up /for the same plans/.


``` ruby
# Get the cache
# Save this in your application's persisted cache
saved_cache = time_pricing.cache

# Setting cache back for another session
TimePricing.new({cache: saved_cache})
```

*Important:* Be sure to clear your externally saved cache if you add, remove or change plans.


## ⚠️ Known Issues

If you have smaller duration plans and are looking for pricing for a large duration, you might encounter `stack level too deep` error. Consider limiting the duration you query a pricing for.   


## 🤓 Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/identitysquare/time_pricing. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

### Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TimePricing project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/time_pricing/blob/master/CODE_OF_CONDUCT.md).

## 🥳 Contributors

<!-- ALL-CONTRIBUTORS-LIST:START -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/Annajoe96"><img src="https://avatars0.githubusercontent.com/u/57370408?v=4" width="100px;" alt=""/><br /><sub><b>Anna Joe</b></sub></a></td>
    <td align="center"><a href="https://github.com/danielpaul"><img src="https://avatars3.githubusercontent.com/u/333233?v=4" width="100px;" alt=""/><br /><sub><b>Daniel Paul</b></sub></a></td>
    <td align="center"><a href="https://github.com/iJohnPaul"><img src="https://avatars0.githubusercontent.com/u/25507937?v=4" width="100px;" alt=""/><br /><sub><b>John Paul</b></sub></a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->
