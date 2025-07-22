
# frozen_string_literal: true
# Interpretador principal da linguagem Lox em Ruby



require_relative "lox_callable"
require_relative "environment"
require_relative "ast"
require_relative "lox_error"
require_relative "abs_function"



# Exceção para retorno de função
class Return < StandardError
  attr_reader :value

  def initialize(value)
    super()
    @value = value
  end
end


# Implementação de função definida pelo usuário
class LoxFunction < LoxCallable
  def initialize(declaration, closure)
    @declaration = declaration
    @closure = closure
  end

  def arity
    @declaration.params.length
  end

  def call(interpreter, arguments)
    environment = Environment.new(@closure)
    @declaration.params.each_with_index do |param, index|
      environment.define(param.lexeme, arguments[index])
    end
    begin
      interpreter.execute_block(@declaration.body, environment)
    rescue Return => return_value
      return return_value.value
    end
    nil
  end

  def to_s
    "<fn #{@declaration.name.lexeme}>"
  end
end

# Função nativa clock()
class ClockFunction < LoxCallable
  def arity; 0; end
  def call(_interpreter, _arguments)
    Time.now.to_f
  end
  def to_s; "<native fn>"; end
end

# Exemplo de função nativa extra: retorna PI
class PiFunction < LoxCallable
  def arity; 0; end
  def call(_interpreter, _arguments)
    Math::PI
  end
  def to_s; "<native fn>"; end
end

# Interpreter executes the AST using the visitor pattern

# Interpretador principal
class Interpreter
  def initialize
    @globals = Environment.new
    @environment = @globals
    # Funções nativas
    @globals.define("clock", ClockFunction.new)
    @globals.define("pi", PiFunction.new)
    @globals.define("abs", AbsFunction.new)
  end

  def interpret(statements)
    statements.each do |statement|
      execute(statement) if statement
    end
  rescue LoxRuntimeError => error
    Lox.runtime_error(error)
  end

  # Statement visitors
  def visit_expression_stmt(stmt)
    evaluate(stmt.expression)
    nil
  end

  def visit_function_stmt(stmt)
    function = LoxFunction.new(stmt, @environment)
    @environment.define(stmt.name.lexeme, function)
    nil
  end

  def visit_if_stmt(stmt)
    if truthy?(evaluate(stmt.condition))
      execute(stmt.then_branch)
    elsif stmt.else_branch
      execute(stmt.else_branch)
    end
    nil
  end

  def visit_print_stmt(stmt)
    value = evaluate(stmt.expression)
    puts stringify(value)
    nil
  end

  def visit_return_stmt(stmt)
    value = nil
    value = evaluate(stmt.value) if stmt.value

    raise Return.new(value)
  end

  def visit_var_stmt(stmt)
    value = nil
    value = evaluate(stmt.initializer) if stmt.initializer

    @environment.define(stmt.name.lexeme, value)
    nil
  end

  def visit_while_stmt(stmt)
    while truthy?(evaluate(stmt.condition))
      execute(stmt.body)
    end
    nil
  end

  def visit_block_stmt(stmt)
    execute_block(stmt.statements, Environment.new(@environment))
    nil
  end

  def execute_block(statements, environment)
    previous = @environment
    begin
      @environment = environment
      statements.each { |statement| execute(statement) if statement }
    ensure
      @environment = previous
    end
  end

  # Expression visitors
  def visit_assign_expr(expr)
    value = evaluate(expr.value)
    @environment.assign(expr.name, value)
    value
  end

  def visit_binary_expr(expr)
    left = evaluate(expr.left)
    right = evaluate(expr.right)

    case expr.operator.type
    when TokenType::GREATER
      check_number_operands(expr.operator, left, right)
      left > right
    when TokenType::GREATER_EQUAL
      check_number_operands(expr.operator, left, right)
      left >= right
    when TokenType::LESS
      check_number_operands(expr.operator, left, right)
      left < right
    when TokenType::LESS_EQUAL
      check_number_operands(expr.operator, left, right)
      left <= right
    when TokenType::BANG_EQUAL
      !equal?(left, right)
    when TokenType::EQUAL_EQUAL
      equal?(left, right)
    when TokenType::MINUS
      check_number_operands(expr.operator, left, right)
      left - right
    when TokenType::PLUS
      if (left.is_a?(Float) || left.is_a?(Integer)) && (right.is_a?(Float) || right.is_a?(Integer))
        left + right
      elsif left.is_a?(String) && right.is_a?(String)
        left + right
      elsif left.is_a?(String)
        left + stringify(right)
      elsif right.is_a?(String)
        stringify(left) + right
      else
        raise LoxRuntimeError.new("Operands must be two numbers or two strings.", expr.operator)
      end
    when TokenType::SLASH
      check_number_operands(expr.operator, left, right)
      raise LoxRuntimeError.new("Division by zero.", expr.operator) if right == 0 || right == 0.0
      left / right
    when TokenType::STAR
      check_number_operands(expr.operator, left, right)
      left * right
    end
  end

  def visit_call_expr(expr)
    callee = evaluate(expr.callee)

    arguments = expr.arguments.map { |arg| evaluate(arg) }

    unless callee.is_a?(LoxCallable)
      raise LoxRuntimeError.new("Can only call functions and classes.", expr.paren)
    end

    if arguments.length != callee.arity
      raise LoxRuntimeError.new("Expected #{callee.arity} arguments but got #{arguments.length}.", expr.paren)
    end

    callee.call(self, arguments)
  end

  def visit_grouping_expr(expr)
    evaluate(expr.expression)
  end

  def visit_literal_expr(expr)
    expr.value
  end

  def visit_logical_expr(expr)
    left = evaluate(expr.left)

    if expr.operator.type == TokenType::OR
      return left if truthy?(left)
    else
      return left unless truthy?(left)
    end

    evaluate(expr.right)
  end

  def visit_unary_expr(expr)
    right = evaluate(expr.right)

    case expr.operator.type
    when TokenType::MINUS
      check_number_operand(expr.operator, right)
      -right
    when TokenType::BANG
      !truthy?(right)
    end
  end

  def visit_variable_expr(expr)
    @environment.get(expr.name)
  end

  private

  def evaluate(expr)
    expr.accept(self)
  end

  def execute(stmt)
    stmt.accept(self)
  end

  def truthy?(object)
    return false if object.nil?
    return object if object.is_a?(TrueClass) || object.is_a?(FalseClass)

    true
  end

  def equal?(a, b)
    return true if a.nil? && b.nil?
    return false if a.nil?

    a == b
  end

  def check_number_operand(operator, operand)
    return if operand.is_a?(Float) || operand.is_a?(Integer)
    raise LoxRuntimeError.new("Operand must be a number.", operator)
  end

  def check_number_operands(operator, left, right)
    return if (left.is_a?(Float) || left.is_a?(Integer)) && (right.is_a?(Float) || right.is_a?(Integer))
    raise LoxRuntimeError.new("Operands must be numbers.", operator)
  end

  def stringify(object)
    return "nil" if object.nil?
    if object.is_a?(Float)
      text = object.to_s
      text = text.chomp(".0") if text.end_with?(".0")
      return text
    end
    if object.is_a?(Integer)
      return object.to_s
    end
    if object == true
      return "true"
    end
    if object == false
      return "false"
    end
    object.to_s
  end
end