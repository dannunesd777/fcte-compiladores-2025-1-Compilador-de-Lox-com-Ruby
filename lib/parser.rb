# frozen_string_literal: true

require_relative "token"
require_relative "ast"
require_relative "token_type"
require_relative "lox_error"
require_relative "expr"
require_relative "stmt"

# Parser performs syntax analysis, building an AST from tokens
class Parser
  class ParseError < StandardError; end

  def initialize(tokens)
    @tokens = tokens
    @current = 0
  end

  def parse
    statements = []
    until at_end?
      statements << declaration
    end
    statements
  end

  private

  def declaration
    return fun_declaration if match(TokenType::FUN)
    return var_declaration if match(TokenType::VAR)

    statement
  rescue ParseError
    synchronize
    nil
  end

  def fun_declaration
    name = consume(TokenType::IDENTIFIER, "Expected function name.")
    consume(TokenType::LEFT_PAREN, "Expected '(' after function name.")
    
    parameters = []
    unless check(TokenType::RIGHT_PAREN)
      loop do
        if parameters.length >= 255
          error(peek, "Can't have more than 255 parameters.")
        end
        
        parameters << consume(TokenType::IDENTIFIER, "Expected parameter name.")
        break unless match(TokenType::COMMA)
      end
    end
    
    consume(TokenType::RIGHT_PAREN, "Expected ')' after parameters.")
    consume(TokenType::LEFT_BRACE, "Expected '{' before function body.")
    body = block

    FunctionStmt.new(name, parameters, body)
  end

  def var_declaration
    name = consume(TokenType::IDENTIFIER, "Expected variable name.")

    initializer = nil
    initializer = expression if match(TokenType::EQUAL)

    consume(TokenType::SEMICOLON, "Expected ';' after variable declaration.")
    VarStmt.new(name, initializer)
  end

  def statement
    return for_statement if match(TokenType::FOR)
    return if_statement if match(TokenType::IF)
    return print_statement if match(TokenType::PRINT)
    return return_statement if match(TokenType::RETURN)
    return while_statement if match(TokenType::WHILE)
    return BlockStmt.new(block) if match(TokenType::LEFT_BRACE)

    expression_statement
  end

  def for_statement
    consume(TokenType::LEFT_PAREN, "Expected '(' after 'for'.")

    # Initializer
    initializer = if match(TokenType::SEMICOLON)
                    nil
                  elsif match(TokenType::VAR)
                    var_declaration
                  else
                    expression_statement
                  end

    # Condition
    condition = nil
    condition = expression unless check(TokenType::SEMICOLON)
    consume(TokenType::SEMICOLON, "Expected ';' after for loop condition.")

    # Increment
    increment = nil
    increment = expression unless check(TokenType::RIGHT_PAREN)
    consume(TokenType::RIGHT_PAREN, "Expected ')' after for clauses.")

    # Body
    body = statement

    # Desugar into while loop
    if increment
      body = BlockStmt.new([body, ExpressionStmt.new(increment)])
    end

    condition = LiteralExpr.new(true) if condition.nil?
    body = WhileStmt.new(condition, body)

    if initializer
      body = BlockStmt.new([initializer, body])
    end

    body
  end

  def if_statement
    consume(TokenType::LEFT_PAREN, "Expected '(' after 'if'.")
    condition = expression
    consume(TokenType::RIGHT_PAREN, "Expected ')' after if condition.")

    then_branch = statement
    else_branch = nil
    else_branch = statement if match(TokenType::ELSE)

    IfStmt.new(condition, then_branch, else_branch)
  end

  def print_statement
    value = expression
    consume(TokenType::SEMICOLON, "Expected ';' after value.")
    PrintStmt.new(value)
  end

  def return_statement
    keyword = previous
    value = nil
    value = expression unless check(TokenType::SEMICOLON)

    consume(TokenType::SEMICOLON, "Expected ';' after return value.")
    ReturnStmt.new(keyword, value)
  end

  def while_statement
    consume(TokenType::LEFT_PAREN, "Expected '(' after 'while'.")
    condition = expression
    consume(TokenType::RIGHT_PAREN, "Expected ')' after condition.")
    body = statement

    WhileStmt.new(condition, body)
  end

  def block
    statements = []

    until check(TokenType::RIGHT_BRACE) || at_end?
      statements << declaration
    end

    consume(TokenType::RIGHT_BRACE, "Expected '}' after block.")
    statements
  end

  def expression_statement
    expr = expression
    consume(TokenType::SEMICOLON, "Expected ';' after expression.")
    ExpressionStmt.new(expr)
  end

  def expression
    assignment
  end

  def assignment
    expr = or_expr

    if match(TokenType::EQUAL)
      equals = previous
      value = assignment

      if expr.is_a?(VariableExpr)
        name = expr.name
        return AssignExpr.new(name, value)
      end

      error(equals, "Invalid assignment target.")
    end

    expr
  end

  def or_expr
    expr = and_expr

    while match(TokenType::OR)
      operator = previous
      right = and_expr
      expr = LogicalExpr.new(expr, operator, right)
    end

    expr
  end

  def and_expr
    expr = equality

    while match(TokenType::AND)
      operator = previous
      right = equality
      expr = LogicalExpr.new(expr, operator, right)
    end

    expr
  end

  def equality
    expr = comparison

    while match(TokenType::BANG_EQUAL, TokenType::EQUAL_EQUAL)
      operator = previous
      right = comparison
      expr = BinaryExpr.new(expr, operator, right)
    end

    expr
  end

  def comparison
    expr = term

    while match(TokenType::GREATER, TokenType::GREATER_EQUAL, TokenType::LESS, TokenType::LESS_EQUAL)
      operator = previous
      right = term
      expr = BinaryExpr.new(expr, operator, right)
    end

    expr
  end

  def term
    expr = factor

    while match(TokenType::MINUS, TokenType::PLUS)
      operator = previous
      right = factor
      expr = BinaryExpr.new(expr, operator, right)
    end

    expr
  end

  def factor
    expr = unary

    while match(TokenType::SLASH, TokenType::STAR)
      operator = previous
      right = unary
      expr = BinaryExpr.new(expr, operator, right)
    end

    expr
  end

  def unary
    if match(TokenType::BANG, TokenType::MINUS)
      operator = previous
      right = unary
      return UnaryExpr.new(operator, right)
    end

    call
  end

  def call
    expr = primary

    loop do
      if match(TokenType::LEFT_PAREN)
        expr = finish_call(expr)
      else
        break
      end
    end

    expr
  end

  def finish_call(callee)
    arguments = []

    unless check(TokenType::RIGHT_PAREN)
      loop do
        if arguments.length >= 255
          error(peek, "Can't have more than 255 arguments.")
        end
        arguments << expression
        break unless match(TokenType::COMMA)
      end
    end

    paren = consume(TokenType::RIGHT_PAREN, "Expected ')' after arguments.")
    CallExpr.new(callee, paren, arguments)
  end

  def primary
    return LiteralExpr.new(false) if match(TokenType::FALSE)
    return LiteralExpr.new(true) if match(TokenType::TRUE)
    return LiteralExpr.new(nil) if match(TokenType::NIL)

    if match(TokenType::NUMBER, TokenType::STRING)
      return LiteralExpr.new(previous.literal)
    end

    if match(TokenType::IDENTIFIER)
      return VariableExpr.new(previous)
    end

    if match(TokenType::LEFT_PAREN)
      expr = expression
      consume(TokenType::RIGHT_PAREN, "Expected ')' after expression.")
      return GroupingExpr.new(expr)
    end

    raise error(peek, "Expected expression.")
  end

  def match(*types)
    types.each do |type|
      if check(type)
        advance
        return true
      end
    end
    false
  end

  def check(type)
    return false if at_end?

    peek.type == type
  end

  def advance
    @current += 1 unless at_end?
    previous
  end

  def at_end?
    peek.type == TokenType::EOF
  end

  def peek
    @tokens[@current]
  end

  def previous
    @tokens[@current - 1]
  end

  def consume(type, message)
    return advance if check(type)

    raise error(peek, message)
  end

  def error(token, message)
    Lox.error(token, message)
    ParseError.new
  end

  def synchronize
    advance

    until at_end?
      return if previous.type == TokenType::SEMICOLON

      case peek.type
      when TokenType::CLASS, TokenType::FUN, TokenType::VAR, TokenType::FOR,
           TokenType::IF, TokenType::WHILE, TokenType::PRINT, TokenType::RETURN
        return
      end

      advance
    end
  end
end
