# frozen_string_literal: true

# Environment manages variable scoping and storage
class Environment
  def initialize(enclosing = nil)
    @enclosing = enclosing
    @values = {}
  end

  def define(name, value)
    @values[name] = value
  end

  def get(name)
    if @values.key?(name.lexeme)
      return @values[name.lexeme]
    end

    if @enclosing
      return @enclosing.get(name)
    end

    raise RuntimeError.new(name, "Undefined variable '#{name.lexeme}'.")
  end

  def assign(name, value)
    if @values.key?(name.lexeme)
      @values[name.lexeme] = value
      return
    end

    if @enclosing
      @enclosing.assign(name, value)
      return
    end

    raise RuntimeError.new(name, "Undefined variable '#{name.lexeme}'.")
  end
end