# Time Pricing

Calculate time based pricing based on duration or start + end time. Useful for services, bookings or appointments where pricing is based on duration. 

# Getting Started

```
gem "time_pricing"
```

### 1. Setup available packages.

Initialize the service and define available packages. 

The cost is a positive integer representing how much to charge in the smallest currency unit (e.g., 100 cents to charge $1.00 or 100 to charge ¥100, a zero-decimal currency).

```
time_pricing = TimePricing.new

time_pricing.add_package!(name: 'per hour', duration: 1.hour, cost: 1000) # €10.00
time_pricing.add_package!(name: 'per day', duration: 1.day, cost: 2000) # €20.00
time_pricing.add_package!(name: 'per week', duration: 1.month, cost: 100000) # €100.00
```

### 2. Pass in start time and end time (or duration) to calculate pricing for that time. 

```
time_pricing.calculate_price(Time.now, Time.now + 6.hours)
```

This would return a hash with all the details:

```

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


