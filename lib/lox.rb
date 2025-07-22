# lox.rb
# Arquivo principal para rodar o interpretador Lox em Ruby
require_relative './scanner'
require_relative './parser'
require_relative './interpreter'
require_relative './expr'
require_relative './stmt'

if ARGV.length < 1
  puts 'Uso: ruby lox.rb caminho/para/arquivo.lox'
  exit 1
end

source = File.read(ARGV[0])
scanner = Scanner.new(source)
tokens = scanner.scan_tokens
parser = Parser.new(tokens)
statements = parser.parse
interpreter = Interpreter.new
interpreter.interpret(statements) 