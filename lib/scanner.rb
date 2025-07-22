# frozen_string_literal: true

require_relative "token"

# Scanner performs lexical analysis, converting source code into tokens
class Scanner
  KEYWORDS = {
    "and" => TokenType::AND,
    "class" => TokenType::CLASS,
    "else" => TokenType::ELSE,
    "false" => TokenType::FALSE,
    "for" => TokenType::FOR,
    "fun" => TokenType::FUN,
    "if" => TokenType::IF,
    "nil" => TokenType::NIL,
    "or" => TokenType::OR,
    "print" => TokenType::PRINT,
    "return" => TokenType::RETURN,
    "super" => TokenType::SUPER,
    "this" => TokenType::THIS,
    "true" => TokenType::TRUE,
    "var" => TokenType::VAR,
    "while" => TokenType::WHILE
  }.freeze

  def initialize(source)
    @source = source
    @tokens = []
    @start = 0
    @current = 0
    @line = 1
  end

  def scan_tokens
    until at_end?
      @start = @current
      scan_token
    end

    @tokens << Token.new(TokenType::EOF, "", nil, @line)
    @tokens
  end

  private

  def at_end?
    @current >= @source.length
  end

  def scan_token
    c = advance

    case c
    when "(" then add_token(TokenType::LEFT_PAREN)
    when ")" then add_token(TokenType::RIGHT_PAREN)
    when "{" then add_token(TokenType::LEFT_BRACE)
    when "}" then add_token(TokenType::RIGHT_BRACE)
    when "," then add_token(TokenType::COMMA)
    when "." then add_token(TokenType::DOT)
    when "-" then add_token(TokenType::MINUS)
    when "+" then add_token(TokenType::PLUS)
    when ";" then add_token(TokenType::SEMICOLON)
    when "*" then add_token(TokenType::STAR)
    when "!"
      add_token(match("=") ? TokenType::BANG_EQUAL : TokenType::BANG)
    when "="
      add_token(match("=") ? TokenType::EQUAL_EQUAL : TokenType::EQUAL)
    when "<"
      add_token(match("=") ? TokenType::LESS_EQUAL : TokenType::LESS)
    when ">"
      add_token(match("=") ? TokenType::GREATER_EQUAL : TokenType::GREATER)
    when "/"
      if match("/")
        # Comment goes until end of line
        advance while peek != "\n" && !at_end?
      else
        add_token(TokenType::SLASH)
      end
    when " ", "\r", "\t"
      # Ignore whitespace
    when "\n"
      @line += 1
    when '"'
      string
    else
      if digit?(c)
        number
      elsif alpha?(c)
        identifier
      else
    if defined?(Lox)
      Lox.error(@line, "Unexpected character: #{c}")
    end
      end
    end
  end

  def advance
    char = @source[@current]
    @current += 1
    char
  end

  def match(expected)
    return false if at_end?
    return false if @source[@current] != expected

    @current += 1
    true
  end

  def peek
    return "\0" if at_end?

    @source[@current]
  end

  def peek_next
    return "\0" if @current + 1 >= @source.length

    @source[@current + 1]
  end

  def string
    while peek != '"' && !at_end?
      @line += 1 if peek == "\n"
      advance
    end

    if at_end?
      Lox.error(@line, "Unterminated string.")
      return
    end

    # Closing "
    advance

    # Trim surrounding quotes
    value = @source[@start + 1...@current - 1]
    add_token(TokenType::STRING, value)
  end

  def number
    advance while digit?(peek)

    # Look for fractional part
    if peek == "." && digit?(peek_next)
      # Consume the "."
      advance

      advance while digit?(peek)
    end

    add_token(TokenType::NUMBER, @source[@start...@current].to_f)
  end

  def identifier
    advance while alphanumeric?(peek)

    text = @source[@start...@current]
    type = KEYWORDS[text] || TokenType::IDENTIFIER
    add_token(type)
  end

  def digit?(c)
    c >= "0" && c <= "9"
  end

  def alpha?(c)
    (c >= "a" && c <= "z") ||
      (c >= "A" && c <= "Z") ||
      c == "_"
  end

  def alphanumeric?(c)
    alpha?(c) || digit?(c)
  end

  def add_token(type, literal = nil)
    text = @source[@start...@current]
    @tokens << Token.new(type, text, literal, @line)
  end
end