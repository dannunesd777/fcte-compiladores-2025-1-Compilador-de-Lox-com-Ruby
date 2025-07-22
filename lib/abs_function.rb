# abs_function.rb
# Função nativa para valor absoluto
require_relative "lox_callable"

class AbsFunction < LoxCallable
  def arity; 1; end
  def call(_interpreter, arguments)
    value = arguments[0]
    unless value.is_a?(Float) || value.is_a?(Integer)
      raise LoxRuntimeError.new(nil, "abs() espera um número.")
    end
    value.abs
  end
  def to_s; "<native fn>"; end
end
