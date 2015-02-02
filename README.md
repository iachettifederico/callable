# Callable

Create callable objects on the fly.

It's easy to create a calable object in Ruby (understanding callable
as an object that supports the `#call` method), you just wrap it in a
lambda and that's it. 

Although this approach is correct, it lucks some expresiveness. Wouldn't it
be better to just say:

```ruby
Callable( :i_wasnt_callable_but_i_am_now )
```

This line of code tells you exacly what it's doing.

This gem allows you to do exactly that (see Usage)


## Usage

To use this library, you first need to require it. That's all the setup you need.

```ruby
  require "callable"
```

If you need to return a callable object for some reason, you can do it by invoking the callable method:

```ruby
  c = Callable( :ret_val )
  c.call
  # => ret_val
```

Take into account that if you pass a callable object (such as a
lambda), you'll get it back as the return value:

```ruby
  c = Callable( ->{ :ret_val } )
  c.call
  # => ret_val
  c
  # => #<Proc:0x0000000261e138@-:6 (lambda)>
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

This allows us to have a lot of flexibility. But we could provide the user a way to say the same with a little less code.

If we wrap the policy to call with the Callable method:

```ruby
  def do_if(permission, policies=POLICIES)
    yield if Callable(policies[permission]).call
  end
```

Now we can put the raw value we want to get back without the need of the lambda

```ruby
  POLICIES = {
    development: true
  }
```

Even thou using a lambda adds just a few more characters, in my opinion, it clutters the code. By being able to leave it out, the code reads much better.

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
