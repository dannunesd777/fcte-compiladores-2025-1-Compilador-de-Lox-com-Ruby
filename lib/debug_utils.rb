# debug_utils.rb
# Utilitários de debug para o interpretador Lox em Ruby

module DebugUtils
  def self.print_chunk(chunk, name)
    puts "Chunk: #{name}"
    offset = 0
    while offset < chunk.bytecode.size
      offset = print_instruction(offset, chunk)
    end
  end

  def self.print_instruction(offset, chunk)
    line_number = chunk.read_line(offset) rescue 0
    puts "#{line_number} #{chunk.bytecode[offset].inspect}"
    offset + 1
  end
end 