require "callable/version"

module Callable
  def Callable( callable_or_not, default: Undefined )
    return Callable(default) if callable_or_not.nil? && default != Undefined
    if callable_or_not.respond_to?(:call)
      callable_or_not
    else
      proc { |*args| callable_or_not }
    end
  end

  def callable
    Callable(self)
  end

  def callable?
    self.respond_to?(:call)
  end

  class Undefined < BasicObject; end
  
end

::Object.include(Callable)
