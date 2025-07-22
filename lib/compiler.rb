# compiler.rb
# Módulo de "compilação" para Lox em Ruby (na prática, análise e preparação da AST)
require_relative './scanner'
require_relative './parser'

class Compiler
  def initialize(source)
    @source = source
  end

  def compile
    scanner = Scanner.new(@source)
    tokens = scanner.scan_tokens
    parser = Parser.new(tokens)
    statements = parser.parse
    statements
  end
end 