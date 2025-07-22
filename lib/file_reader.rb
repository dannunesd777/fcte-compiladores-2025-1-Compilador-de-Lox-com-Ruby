# file_reader.rb
# Utilitário para leitura de arquivos em Ruby

class FileReader
  def initialize(filename)
    @filename = filename
  end

  def read_all
    File.read(@filename)
  rescue Errno::ENOENT
    raise LoxFileNotFoundError.new("Arquivo #{@filename} não encontrado")
  end
end 