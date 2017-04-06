# Convertator

A simple currency converter which can use different sources to fetch rates and provides a rack-like middleware feature.

[![Gem Version](https://badge.fury.io/rb/convertator.svg)](https://badge.fury.io/rb/convertator)


## Usage

**Simple example**

```ruby
require 'convertator/converter'

converter = Convertator::Converter.new
converter.convert(100, :USD, :RUB)
=> 0.55e4
converter.convert_digits(100, :USD, :RUB)
=> "5500.0"
```

**Multi convertion**

```ruby
Convertator::Converter.new(:static).convert_multi_s(100, :GBP, [:AMD, :RUB, :GBP])
=> ["47.12398", "3336.69827", "100.0"]
```

**Define accuracy and handler**

```ruby
Convertator::Converter.new(:static, 7)
```

**Use file cache middleware**

```ruby
irb(main):002:0> require 'convertator/middlewares/file_cache_middleware'
=> true
irb(main):003:0> converter = Convertator::Converter.new do |c|
irb(main):004:1*   c.add Convertator::Middlewares::FileCacheMiddleware.new('/tmp/convertator.cache')
irb(main):005:1> end
=> #<Convertator::Converter:0x005642ede40a58>
converter.convert_s(100, :GBP, :RUB)
=> 7000.0
```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'convertator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install convertator


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/convertator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

