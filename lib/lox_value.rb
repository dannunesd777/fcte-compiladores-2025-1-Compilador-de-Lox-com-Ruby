
# lox_value.rb
# Representação de valores e objetos Lox em Ruby
require_relative "lox_callable"

class LoxValue
  attr_reader :type, :value
  def initialize(type, value = nil)
    @type = type
    @value = value
  end

  def to_s
    case type
    when :nil
      'nil'
    when :bool
      value ? 'true' : 'false'
    when :number
      value.to_s
    when :string
      value
    when :obj
      value.to_s
    else
      value.to_s
    end
  end
end

# Tipos de objetos Lox
class LoxString
  attr_reader :str
  def initialize(str)
    @str = str
  end
  def to_s
    @str
  end
end

class LoxFunctionValue
  attr_reader :name, :arity, :body
  def initialize(name, arity, body)
    @name = name
    @arity = arity
    @body = body
  end
  def to_s
    "<function \\#{@name}>"
  end
end

class LoxClass
  attr_reader :name
  def initialize(name)
    @name = name
  end
  def to_s
    "<class #{@name}>"
  end
end

class LoxInstance
  attr_reader :klass, :fields
  def initialize(klass)
    @klass = klass
    @fields = {}
  end
  def get(name)
    @fields[name] || nil
  end
  def set(name, value)
    @fields[name] = value
  end
  def to_s
    "<instance of #{@klass.name}>"
  end
end

class LoxAllocation
  attr_reader :size
  def initialize(size)
    @size = size
  end
  def to_s
    "<allocation of size #{@size}>"
  end
end 