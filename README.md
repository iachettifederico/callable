# Callable

Create callable objects on the fly.

It's easy to create a calable object in Ruby (understandong callable
as an object that supports the call method), you just wrap it in a
lambda and that's it. 

Although this approach is correct, it lucks some expresiveness. Wouldn't it
be better to just say:

```ruby
Callable( :i_wasnt_callable_but_i_am_now )
```

This line of code tells you exacly what it's doing.

This gem allows you to do exactly that (see Usage)


## Usage

If you need to return a callable object for some reason, you can do it
in one of two ways (don't forget to install the gem first).

The first way is by invoking the callable method:

```ruby
  c = Callable( :ret_val )
  c.call
  => ret_val
```

Take into account that if you pass a callable object (such as a
lambda), you'll get it back as the return value:

```ruby
  c = Callable( ->{ :ret_val } )
  c.call
  => ret_val
```

The gem also ships with a #callable? method thar returns true if the
object is callable and false if it's not.

```ruby
  :not_callable.callable?
  => false
  
  ->{ :not_callable }.callable?
  => true
```

This is the same as saying

```ruby
  xxx.respond_to? :call
```

But I felt it would be more illustrative of it's purpose.

## Where to use it?

I think the main use for this library is handling actions as options.

For example, imagine we have a very reduced authorization library that provides a method called `do_if`.
This method receives:
  - a symbol representing a permission name
  - a Hash that represents the available authorization policies
  - a block with the actions to perform

The premise is that the method will execute the block if the selected policy returns true when we send the `call` message.

Our first approach is:

```ruby
  def do_if(permission, policies=POLICIES)
    yield if policies[permission].call
  end
```

So, if our POLICIES hash is:

```ruby
  POLICIES = {
    development: -> { true }
  }
  
  do_if(:development) do
    puts "Debugging"
  end
  
  # >> Debugging
```

And if we switch the policy value:

```ruby
  POLICIES = {
    development: -> { false }
  }
  
  do_if(:development) do
    puts "Debugging"
  end
  
  # >> 
```

This allows us to have a lot of flexibility. But we could provide the user a way to say the same with less code:





*******************************
Let me say where to use this gem with a very
trivial example.

Imagine we have some class that admits an informer object that
responds to the get_info method and returns a some information on a
String.

```ruby
  class SomeClass
    attr_writer :informer
    def info
      @informer.get_info
    end
  end
```

If we want to use this "informer" object, we must define a new class
or module that responds to the "get_info" method.

When we have a case like this, is a common practice to name that
method "call", instead of "get_info", because we now can toss a simple
lambda to substitute it. We can rewrite the code above like this:

```ruby
  class SomeClass
    attr_writer :informer
    def info
      @informer.call
    end
  end
```

And now we can define a class or module that responds to the call
method. In that call method, we can get as fancy as we want:

```ruby
  module Informer
    def call
      # retrieve the information we need from wherever we want
      # maybe a web service
      # maybe a local file
    end
  end
```

So, when we do:

```ruby
  something = SomeClass.new
  something.informer = Informer
  something.info
```

We trigger some weird and complex logic.

But when we test our code (or in some special case), we need that
logic to be as simple (an decoupled) as it can get. 

Say we now want info to return just a fixed string saying "No info
available". With a lambda is fairly easy to do it

```ruby
  something = SomeClass.new
  something.informer = ->{ "No info available" }
  something.info
```

Here is where the Callable gem comes in handy, we could say the same
thing like this:

```ruby
  something = SomeClass.new
  something.informer = Callable("No info available" )
  something.info
```

And now is much more expressive.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'callable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install callable

## Contributing

1. Fork it ( https://github.com/[my-github-username]/callable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
