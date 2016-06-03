# ClosestWeightliftingGem

This application scrapes the [USA Weightlifting's Find a Club ](http://www.teamusa.org/usa-weightlifting/clubs-lwc/find-a-club) feature and builds a Gym object for each club, which includes some basic biographical information.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'closest_weightlifting_gem'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install closest_weightlifting_gem

## Usage



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

TODO:
---
* Geocode gym addresses
* Implement user location input to find nearest gyms

Done(?):
* Implement proper options from CLI#show_gym
* show_gym page from #find_by_names menu should take it back to those search results instead of the state results

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zacscodingclub/closest_weightlifting_gem.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
