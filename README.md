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

## Usage


#### Setup Available Plans

Initialize the service and define available packages. 

The cost is a positive integer representing how much to charge in the smallest currency unit (e.g., 100 cents to charge $1.00 or 100 to charge ¥100, a zero-decimal currency).

``` ruby
plans = [
    {
        name: 'pre hour',
        duration: 1.hour,
        cost: 1000 # €10.00 for an hour
    },
    {
        name: 'per day',
        duration: 1.day,
        cost: 2000 # €20.00 for 1 day
    },
    {
        name: 'per week',
        duration: 1.month,
        cost: 100000 # €100.00 for a week
    }
]


# Calculate with two timestamps

time_pricing = TimePricing.new({plans: plans, start_time: Time.now, end_time: Time.now + 6.hours})

# OR with duration

time_pricing = TimePricing.new({plans: plans, duration: 6.hours})
```

This would return a hash with all the details:

``` ruby
{
  start_time: "",
  end_time: "",
  cheapest_price: true,
  packages: [
    {...},
    {...}
  ],
  pricing_breakdown: [
    {
      start_time: "",
      end_time: "",
      package: "",
      cost: 1000
    },
    {...} 
  ],
  total_price: 1000
}
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


