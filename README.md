# Kindergarten

[![Build Status](https://secure.travis-ci.org/coffeeaddict/kindergarten.png)](http://travis-ci.org/coffeeaddict/kindergarten)

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/coffeeaddict/kindergarten)

A way to achieve modularity and modular security with a sandbox on steroids.

## Installation

Add this line to your application's Gemfile:

    gem 'kindergarten'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kindergarten

## Usage

```ruby
# define a child
child = User.find(2)

# define a module (perimeter) for the child to play in
class MyPlayModule < Kindergarten::Perimeter
  # every module must have a purpose, it is it's namespace
  purpose :playing

  # use can-can rules to govern the perimeter
  govern do
    can :watch, Television
    cannot :watch, CableTV

    can :eat, Candy do |candy|
      child.quotum.allows(candy)
    end
  end

  # define exposed methods
  expose :watch_tv, :eat

  def watch_tv(tv)
    guard(:watch, tv)
    child.watch(tv)

    sleep(:four)
  end

  def eat(candy)
    guard(:eat, candy)
    child.eat(candy)
  end

  def sleep(len) # not_accessible_from_outside
    child.sleep(len)
  end

  # or expose methods in an 'annotation like way'

  expose :method
  # method that does nothing at all
  def method
  end
end

# load the child (any object) and the module into a sandbox
sandbox = Kindergarten.sandbox(child)
sandbox.load_module(MyPlayPerimeter)

# you can now call the sandboxed methods on the sandbox
sandbox.playing.watch_tv(CableTV.new)   # fails with Kindergarten::AccessDenied
30.times do
  sandbox.playing.eat(Liquorice.new)    # fails after a while
end

sandbox.playing.sleep(:long)            # fails with NoMethodError

sandbox.allows?(:watch, Television)
# => true
```

You are not restricted to only one perimeter/module - that would be most
boring...

Infact, the above is the essence of things - but there is much much more fun
hidden inside the Kindergarten. More will follow on the Wiki

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
