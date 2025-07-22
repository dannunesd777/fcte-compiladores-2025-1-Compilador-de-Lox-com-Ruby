# frozen_string_literal: true

require_relative "../lib/scanner"

RSpec.describe Scanner do
  describe "#scan_tokens" do
    it "scans single character tokens" do
      source = "(){},.-+;*"
      scanner = Scanner.new(source)
      tokens = scanner.scan_tokens

      expect(tokens.length).to eq(11) # 10 tokens + EOF
      expect(tokens[0].type).to eq(TokenType::LEFT_PAREN)
      expect(tokens[1].type).to eq(TokenType::RIGHT_PAREN)
      expect(tokens[2].type).to eq(TokenType::LEFT_BRACE)
      expect(tokens[3].type).to eq(TokenType::RIGHT_BRACE)
      expect(tokens[4].type).to eq(TokenType::COMMA)
      expect(tokens[5].type).to eq(TokenType::DOT)
      expect(tokens[6].type).to eq(TokenType::MINUS)
      expect(tokens[7].type).to eq(TokenType::PLUS)
      expect(tokens[8].type).to eq(TokenType::SEMICOLON)
      expect(tokens[9].type).to eq(TokenType::STAR)
      expect(tokens[10].type).to eq(TokenType::EOF)
    end

    it "scans comparison operators" do
      source = "!= == <= >= < >"
      scanner = Scanner.new(source)
      tokens = scanner.scan_tokens

      expect(tokens[0].type).to eq(TokenType::BANG_EQUAL)
      expect(tokens[1].type).to eq(TokenType::EQUAL_EQUAL)
      expect(tokens[2].type).to eq(TokenType::LESS_EQUAL)
      expect(tokens[3].type).to eq(TokenType::GREATER_EQUAL)
      expect(tokens[4].type).to eq(TokenType::LESS)
      expect(tokens[5].type).to eq(TokenType::GREATER)
    end

    it "scans string literals" do
      source = '"hello world"'
      scanner = Scanner.new(source)
      tokens = scanner.scan_tokens

      expect(tokens[0].type).to eq(TokenType::STRING)
      expect(tokens[0].literal).to eq("hello world")
    end

    it "scans number literals" do
      source = "123 123.456"
      scanner = Scanner.new(source)
      tokens = scanner.scan_tokens

      expect(tokens[0].type).to eq(TokenType::NUMBER)
      expect(tokens[0].literal).to eq(123.0)
      expect(tokens[1].type).to eq(TokenType::NUMBER)
      expect(tokens[1].literal).to eq(123.456)
    end

    it "scans keywords" do
      source = "and class else false for fun if nil or print return super this true var while"
      scanner = Scanner.new(source)
      tokens = scanner.scan_tokens

      expected_types = [
        TokenType::AND, TokenType::CLASS, TokenType::ELSE, TokenType::FALSE,
        TokenType::FOR, TokenType::FUN, TokenType::IF, TokenType::NIL,
        TokenType::OR, TokenType::PRINT, TokenType::RETURN, TokenType::SUPER,
        TokenType::THIS, TokenType::TRUE, TokenType::VAR, TokenType::WHILE
      ]

      expected_types.each_with_index do |expected_type, index|
        expect(tokens[index].type).to eq(expected_type)
      end
    end

    it "scans identifiers" do
      source = "myVariable _private class123"
      scanner = Scanner.new(source)
      tokens = scanner.scan_tokens

      expect(tokens[0].type).to eq(TokenType::IDENTIFIER)
      expect(tokens[0].lexeme).to eq("myVariable")
      expect(tokens[1].type).to eq(TokenType::IDENTIFIER)
      expect(tokens[1].lexeme).to eq("_private")
      expect(tokens[2].type).to eq(TokenType::IDENTIFIER)
      expect(tokens[2].lexeme).to eq("class123")
    end

    it "ignores comments" do
      source = "var x = 5; // this is a comment\nprint x;"
      scanner = Scanner.new(source)
      tokens = scanner.scan_tokens

      # Should not include the comment
      expect(tokens.map(&:type)).to eq([
        TokenType::VAR, TokenType::IDENTIFIER, TokenType::EQUAL, TokenType::NUMBER,
        TokenType::SEMICOLON, TokenType::PRINT, TokenType::IDENTIFIER, TokenType::SEMICOLON,
        TokenType::EOF
      ])
    end
  end
end