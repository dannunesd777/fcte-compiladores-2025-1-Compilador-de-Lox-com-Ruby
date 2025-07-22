#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "lib/scanner"
require_relative "lib/parser"
require_relative "lib/interpreter"
require_relative "lib/token"
require_relative "lib/token_type"
require_relative "lib/lox_error"
require_relative "lib/expr"
require_relative "lib/stmt"
require_relative "lib/lox_value"


if ARGV.length > 0
  source = File.read(ARGV[0])
  scanner = Scanner.new(source)
  tokens = scanner.scan_tokens
  parser = Parser.new(tokens)
  statements = parser.parse
  interpreter = Interpreter.new
  interpreter.interpret(statements)
else
  puts "Digite código Lox. CTRL+D para sair."
  interpreter = Interpreter.new
  while line = $stdin.gets
    scanner = Scanner.new(line)
    tokens = scanner.scan_tokens
    parser = Parser.new(tokens)
    statements = parser.parse
    interpreter.interpret(statements)
  end
end

# Main Lox interpreter class
class Lox
  class << self
    attr_accessor :had_error, :had_runtime_error

    def main(args)
      @had_error = false
      @had_runtime_error = false

      if args.length > 1
        puts "Usage: lox [script]"
        exit(64)
      elsif args.length == 1
        run_file(args[0])
      else
        run_prompt
      end
    end

    private

    def run_file(path)
      unless File.exist?(path)
        puts "Error: File '#{path}' not found."
        exit(1)
      end

      source = File.read(path)
      run(source)

      exit(65) if @had_error
      exit(70) if @had_runtime_error
    end

    def run_prompt
      puts "Lox Interactive REPL"
      puts "Type 'exit' to quit."
      
      loop do
        print "> "
        line = gets
        break if line.nil? || line.strip == "exit"

        run(line)
        @had_error = false
      end
    end

    def run(source)
      scanner = Scanner.new(source)
      tokens = scanner.scan_tokens

      parser = Parser.new(tokens)
      statements = parser.parse

      return if @had_error

      interpreter = @interpreter ||= Interpreter.new
      interpreter.interpret(statements)
    end

    def error(line_or_token, message)
      if line_or_token.is_a?(Integer)
        report(line_or_token, "", message)
      else
        token = line_or_token
        if token.type == TokenType::EOF
          report(token.line, " at end", message)
        else
          report(token.line, " at '#{token.lexeme}'", message)
        end
      end
    end

    def runtime_error(error)
      puts "#{error.message}\n[line #{error.token.line}]"
      @had_runtime_error = true
    end

    private

    def report(line, where, message)
      puts "[line #{line}] Error#{where}: #{message}"
      @had_error = true
    end
  end
end

# Run the interpreter if this is the main file
if $PROGRAM_NAME == __FILE__
  Lox.main(ARGV)
end
