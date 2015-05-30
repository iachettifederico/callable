require "spec_helper"

scope Callable do
  spec "creates a callable object" do
    @obj = :not_callable
    @c = Callable(@obj)

    @c.call == @obj
  end

  spec "leaves a callable object intact" do
    @obj = -> { :callable }
    @c = Callable(@obj)

    @c == @obj
  end

  scope "#callable" do
    spec "creates a callable object" do
      @obj = :not_callable
      @c = @obj.callable

      @c.call == @obj
    end

    spec "leaves a callable object intact" do
      @obj = -> { :callable }
      @c = @obj.callable

      @c == @obj
    end

  end

  scope "#callable?" do
    spec "returns true if the object responds to #call" do
      @obj = -> { :callable }

      @obj.callable?
    end

    spec "returns false if the object doesn't respond to #call" do
      @obj = :not_callable

      ! @obj.callable?
    end
  end

  scope "arguments" do
    spec "accepts arguments arguments" do
      @obj = :not_callable
      @c = Callable(@obj)

      @c.call(1, 2, 3) == @obj
    end

    spec "passes the arguments on" do
      @obj = -> (a, b) { a + " " + b }
      @c = Callable(@obj)

      @c.call("Call", "me") == "Call me"
    end

    spec "can pass any number of arguments to a proc" do
      @obj = proc { |a, b| a + " " + b }
      @c = Callable(@obj)

      @c.call("Call", "me", "now") == "Call me"
    end

    spec "passes the arguments on" do
      @obj = -> (*args) { args.join(" ") }
      @c = Callable(@obj)

      @c.call("Call", "me", "now") == "Call me now"
    end
  end
  scope "default value" do
    spec "returns the default value when passing nil" do
      @c = Callable(nil, default: "DEFAULT VALUE")

      @c.call == "DEFAULT VALUE"
    end
  end
end
