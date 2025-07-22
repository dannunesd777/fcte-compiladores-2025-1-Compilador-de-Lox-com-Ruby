# expr.rb
# Classes da AST para expressões em Lox

class Expr
  def accept(visitor)
    raise NotImplementedError
  end
end

class Literal < Expr
  attr_reader :value
  def initialize(value)
    @value = value
  end
  def accept(visitor)
    visitor.visit_literal(self)
  end
end

class Grouping < Expr
  attr_reader :expression
  def initialize(expression)
    @expression = expression
  end
  def accept(visitor)
    visitor.visit_grouping(self)
  end
end

class Unary < Expr
  attr_reader :operator, :right
  def initialize(operator, right)
    @operator = operator
    @right = right
  end
  def accept(visitor)
    visitor.visit_unary(self)
  end
end

class Binary < Expr
  attr_reader :left, :operator, :right
  def initialize(left, operator, right)
    @left = left
    @operator = operator
    @right = right
  end
  def accept(visitor)
    visitor.visit_binary(self)
  end
end

class VariableExpr < Expr
  attr_reader :name
  def initialize(name)
    @name = name
  end
  def accept(visitor)
    visitor.visit_variable(self)
  end
end

class AssignExpr < Expr
  attr_reader :name, :value
  def initialize(name, value)
    @name = name
    @value = value
  end
  def accept(visitor)
    visitor.visit_assign(self)
  end
end

class GetExpr < Expr
  attr_reader :object, :name
  def initialize(object, name)
    @object = object
    @name = name
  end
  def accept(visitor)
    visitor.visit_get(self)
  end
end

class SetExpr < Expr
  attr_reader :object, :name, :value
  def initialize(object, name, value)
    @object = object
    @name = name
    @value = value
  end
  def accept(visitor)
    visitor.visit_set(self)
  end
end

class CallExpr < Expr
  attr_reader :callee, :paren, :arguments
  def initialize(callee, paren, arguments)
    @callee = callee
    @paren = paren
    @arguments = arguments
  end
  def accept(visitor)
    visitor.visit_call(self)
  end
end

class ThisExpr < Expr
  attr_reader :keyword
  def initialize(keyword)
    @keyword = keyword
  end
  def accept(visitor)
    visitor.visit_this(self)
  end
end 