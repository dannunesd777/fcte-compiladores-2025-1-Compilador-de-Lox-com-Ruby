# frozen_string_literal: true

# Base class for all expression nodes in the AST
class Expr
  def accept(visitor)
    raise NotImplementedError, "Subclasses must implement accept method"
  end
end

# Binary expression: left operator right
class BinaryExpr < Expr
  attr_reader :left, :operator, :right

  def initialize(left, operator, right)
    @left = left
    @operator = operator
    @right = right
  end

  def accept(visitor)
    visitor.visit_binary_expr(self)
  end
end

# Grouping expression: (expression)
class GroupingExpr < Expr
  attr_reader :expression

  def initialize(expression)
    @expression = expression
  end

  def accept(visitor)
    visitor.visit_grouping_expr(self)
  end
end

# Literal values: numbers, strings, booleans, nil
class LiteralExpr < Expr
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def accept(visitor)
    visitor.visit_literal_expr(self)
  end
end

# Unary expression: -expression, !expression
class UnaryExpr < Expr
  attr_reader :operator, :right

  def initialize(operator, right)
    @operator = operator
    @right = right
  end

  def accept(visitor)
    visitor.visit_unary_expr(self)
  end
end

# Variable expression: identifier
class VariableExpr < Expr
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def accept(visitor)
    visitor.visit_variable_expr(self)
  end
end

# Assignment expression: identifier = value
class AssignExpr < Expr
  attr_reader :name, :value

  def initialize(name, value)
    @name = name
    @value = value
  end

  def accept(visitor)
    visitor.visit_assign_expr(self)
  end
end

# Logical expression: left and/or right
class LogicalExpr < Expr
  attr_reader :left, :operator, :right

  def initialize(left, operator, right)
    @left = left
    @operator = operator
    @right = right
  end

  def accept(visitor)
    visitor.visit_logical_expr(self)
  end
end

# Call expression: function(arguments)
class CallExpr < Expr
  attr_reader :callee, :paren, :arguments

  def initialize(callee, paren, arguments)
    @callee = callee
    @paren = paren
    @arguments = arguments
  end

  def accept(visitor)
    visitor.visit_call_expr(self)
  end
end

# Base class for all statement nodes
class Stmt
  def accept(visitor)
    raise NotImplementedError, "Subclasses must implement accept method"
  end
end

# Expression statement: expression;
class ExpressionStmt < Stmt
  attr_reader :expression

  def initialize(expression)
    @expression = expression
  end

  def accept(visitor)
    visitor.visit_expression_stmt(self)
  end
end

# Print statement: print expression;
class PrintStmt < Stmt
  attr_reader :expression

  def initialize(expression)
    @expression = expression
  end

  def accept(visitor)
    visitor.visit_print_stmt(self)
  end
end

# Variable declaration: var identifier = expression;
class VarStmt < Stmt
  attr_reader :name, :initializer

  def initialize(name, initializer)
    @name = name
    @initializer = initializer
  end

  def accept(visitor)
    visitor.visit_var_stmt(self)
  end
end

# Block statement: { statements }
class BlockStmt < Stmt
  attr_reader :statements

  def initialize(statements)
    @statements = statements
  end

  def accept(visitor)
    visitor.visit_block_stmt(self)
  end
end

# If statement: if (condition) then_branch else else_branch
class IfStmt < Stmt
  attr_reader :condition, :then_branch, :else_branch

  def initialize(condition, then_branch, else_branch)
    @condition = condition
    @then_branch = then_branch
    @else_branch = else_branch
  end

  def accept(visitor)
    visitor.visit_if_stmt(self)
  end
end

# While statement: while (condition) body
class WhileStmt < Stmt
  attr_reader :condition, :body

  def initialize(condition, body)
    @condition = condition
    @body = body
  end

  def accept(visitor)
    visitor.visit_while_stmt(self)
  end
end

# Function declaration: fun name(parameters) { body }
class FunctionStmt < Stmt
  attr_reader :name, :params, :body

  def initialize(name, params, body)
    @name = name
    @params = params
    @body = body
  end

  def accept(visitor)
    visitor.visit_function_stmt(self)
  end
end

# Return statement: return expression;
class ReturnStmt < Stmt
  attr_reader :keyword, :value

  def initialize(keyword, value)
    @keyword = keyword
    @value = value
  end

  def accept(visitor)
    visitor.visit_return_stmt(self)
  end
end