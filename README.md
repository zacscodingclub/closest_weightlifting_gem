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

## Development

To interact with the command line interface, clone the repo locally and change directories into the new folder.   Then you can run `bundle install` or `bin/setup` from the terminal prompt to install dependencies that aren't already on your system. Then, call the full program by typing `bin/closest-weightlifting-gem` into the prompt.  Note:  It scrapes everything up front so that I can query against the entire set of 1168 gyms (as of June 11 2016).

You can also run `bin/console` for an interactive prompt that will allow you to experiment. From within this console, you can call `basic_setup` and it will scrape all the gyms in Florida, Illinois, and New York to add some data into the system.

TODO:
---
* DRY up Scraper class
* Hook up to ActiveRecord
* Geocode gym addresses
* Implement user location input to find nearest gyms
* Map

Done:
---
* Implement proper options from CLI#show_gym
* show_gym page from #find_by_names menu should take it back to those search results instead of the state results

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zacscodingclub/closest_weightlifting_gem.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
