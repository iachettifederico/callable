require "spec_helper"
require "callable"

RSpec.describe Callable do
  it "creates a callable object" do
    c = Callable('NOT CALLABLE')

    expect(c.call).to eql('NOT CALLABLE')
  end

  it "leaves a callable object intact" do
    obj = -> { 'whatever' }
    c = Callable(obj)

    expect(c).to eql(obj)
  end

  describe "#callable" do
    it "creates a callable object" do
      obj = 'NOT CALLABLE'
      c = obj.callable

      expect(c.call).to eql(obj)
    end

    it "leaves a callable object intact" do
      obj = -> { 'CALLABLE' }
      c = obj.callable

      expect(c).to eql(obj)
    end

  end

  describe "#callable?" do
    it "returns true if the object responds to #call" do
      obj = -> { 'CALLABLE' }

      expect(obj.callable?).to eql(true)
    end

    it "returns false if the object doesn't respond to #call" do
      obj = 'NOT CALLABLE'

      expect(obj.callable?).to eql(false)
    end
  end

  describe "arguments" do
    it "accepts arguments arguments" do
      obj = 'NOT CALLABLE'
      c = Callable(obj)

      expect(c.call(1, 2, 3)).to eql('NOT CALLABLE')
    end

    it "passes the arguments on" do
      obj = -> (a, b) { a + " " + b }
      c = Callable(obj)

      expect(c.call("Call", "me")).to eql("Call me")
    end

    it "can pass any number of arguments to a proc" do
      obj = proc { |a, b| a + " " + b }
      c = Callable(obj)

      expect(c.call("Call", "me", "now")).to eql("Call me")
    end

    it "passes the arguments on" do
      obj = -> (*args) { args.join(" ") }
      c = Callable(obj)

      expect(c.call("Call", "me", "now")).to eql("Call me now")
    end
  end

  describe "default value" do
    it "the default default value is nil" do
      c = Callable(nil)

      expect(c.call).to eql(nil)
    end

    it "returns the default value when passing nil" do
      c = Callable(nil, default: "DEFAULT VALUE")

      expect(c.call).to eql("DEFAULT VALUE")
    end
  end
end
