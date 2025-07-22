# memory.rb
# Simulação de gerenciamento de memória para Lox em Ruby

class Memory
  attr_reader :heap_objects

  def initialize
    @heap_objects = []
  end

  def allocate(obj)
    @heap_objects << obj
    obj
  end

  def free_all
    @heap_objects.clear
  end

  def collect_garbage
    # Em Ruby, o GC é automático, mas podemos simular logs
    puts '[DEBUG] Coletando lixo (simulado)'
    # Aqui poderíamos remover objetos não referenciados, se necessário
  end
end 