# lox_callable.rb
# Interface para funções chamáveis (usuário e nativas) no interpretador Lox

class LoxCallable
  def arity
    raise NotImplementedError
  end

  def call(interpreter, arguments)
    raise NotImplementedError
  end
end
