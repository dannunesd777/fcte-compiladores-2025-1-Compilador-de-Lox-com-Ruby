# stmt.rb
# Classes da AST para comandos em Lox

class Stmt
  def accept(visitor)
    raise NotImplementedError
  end
end

class ExpressionStmt < Stmt
  attr_reader :expression
  def initialize(expression)
    @expression = expression
  end
  def accept(visitor)
    visitor.visit_expression_stmt(self)
  end
end

class PrintStmt < Stmt
  attr_reader :expression
  def initialize(expression)
    @expression = expression
  end
  def accept(visitor)
    visitor.visit_print_stmt(self)
  end
end

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

class BlockStmt < Stmt
  attr_reader :statements
  def initialize(statements)
    @statements = statements
  end
  def accept(visitor)
    visitor.visit_block_stmt(self)
  end
end

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

class ClassStmt < Stmt
  attr_reader :name, :methods
  def initialize(name, methods)
    @name = name
    @methods = methods
  end
  def accept(visitor)
    visitor.visit_class_stmt(self)
  end
end 