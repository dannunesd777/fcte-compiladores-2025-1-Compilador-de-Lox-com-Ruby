# lox_error.rb
# Definição das classes de erro para o interpretador Lox em Ruby

class LoxError < StandardError
  attr_reader :line, :pos
  def initialize(message, line = -1, pos = -1)
    prefix = ""
    if line != -1
      if pos != -1
        prefix += "[Line #{line}:#{pos}] "
      else
        prefix += "[Line #{line}] "
      end
    end
    super("#{prefix}Error: #{message}")
    @line = line
    @pos = pos
  end
end

class LoxScanningError < LoxError
  def initialize(message, line, pos)
    super("Scanning Error: #{message}", line, pos)
  end
end

class LoxRuntimeError < LoxError
  def initialize(message, line = -1)
    super("Runtime Error: #{message}", line)
  end
end

class LoxFileNotFoundError < LoxError
  def initialize(message)
    super(message)
  end
end

class LoxCompileError < LoxError
  def initialize(message, line)
    super("Compile Error: #{message}", line)
  end
end 