# Caching

[![Gem Version](https://badge.fury.io/rb/caching.png)](https://rubygems.org/gems/caching)
[![Build Status](https://travis-ci.org/gabynaiman/caching.png?branch=master)](https://travis-ci.org/gabynaiman/caching)
[![Coverage Status](https://coveralls.io/repos/gabynaiman/caching/badge.png?branch=master)](https://coveralls.io/r/gabynaiman/caching?branch=master)
[![Code Climate](https://codeclimate.com/github/gabynaiman/caching.png)](https://codeclimate.com/github/gabynaiman/caching)
[![Dependency Status](https://gemnasium.com/gabynaiman/caching.png)](https://gemnasium.com/gabynaiman/caching)

Cache methods

## Installation

Add this line to your application's Gemfile:

    gem 'caching'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install caching

## Usage

    class Model
      def slow_method
        ...
      end
      cache_method :slow_method

      def slow_method_with_args(*args)
        ...
      end
      cache_method :slow_method_with_args

      def fast_method
        ...
      end
    end

    model = Model.new
    
    model.slow_method # => Execute method
    model.slow_method # => Return cached value

    model.slow_method_with_args 'some value' # => Execute method
    model.slow_method_with_args 'some value' # => Return cached value for argument 'some value'

    model.slow_method_with_args 1234 # => Execute method
    model.slow_method_with_args 1234 # => Return cached value for argument 1234

    model.clear_cache :slow_method # => Remove cache only for method slow_method

    model.clear_cache # => Remove cache for all cached methods

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
