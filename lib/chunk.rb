# chunk.rb
# Representação de um Chunk de bytecode (ou instruções) em Ruby

class Chunk
  attr_reader :bytecode, :constants, :lines

  def initialize
    @bytecode = []
    @constants = []
    @lines = []
  end

  def write(code, line)
    @bytecode << code
    write_line(line)
    @bytecode.size - 1
  end

  def write_constant(value)
    @constants << value
    @constants.size - 1
  end

  def read_constant(offset)
    @constants[offset]
  end

  def write_line(line)
    if @lines.empty? || @lines[-2] != line
      @lines << line
      @lines << 1
    else
      @lines[-1] += 1
    end
  end

  def read_line(instruction_offset)
    current_offset = @lines[1]
    index = 0
    while instruction_offset + 1 > current_offset
      index += 2
      current_offset += @lines[index + 1]
    end
    @lines[index]
  end
end 