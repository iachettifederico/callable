module Callable
  def Callable( callable_or_not )
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
end

Object.include(Callable)
  
