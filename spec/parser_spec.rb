# frozen_string_literal: true

require_relative "../lib/parser"
require_relative "../lib/scanner"

RSpec.describe Parser do
  def parse_expression(source)
    scanner = Scanner.new(source)
    tokens = scanner.scan_tokens
    parser = Parser.new(tokens)
    statements = parser.parse
    statements.first.expression if statements.first.is_a?(ExpressionStmt)
  end

  describe "#parse" do
    it "parses literal expressions" do
      expr = parse_expression("42;")
      expect(expr).to be_a(LiteralExpr)
      expect(expr.value).to eq(42.0)

      expr = parse_expression('"hello";')
      expect(expr).to be_a(LiteralExpr)
      expect(expr.value).to eq("hello")

      expr = parse_expression("true;")
      expect(expr).to be_a(LiteralExpr)
      expect(expr.value).to eq(true)

      expr = parse_expression("nil;")
      expect(expr).to be_a(LiteralExpr)
      expect(expr.value).to be_nil
    end

    it "parses binary expressions" do
      expr = parse_expression("1 + 2;")
      expect(expr).to be_a(BinaryExpr)
      expect(expr.operator.type).to eq(TokenType::PLUS)
      expect(expr.left).to be_a(LiteralExpr)
      expect(expr.right).to be_a(LiteralExpr)
    end

    it "parses unary expressions" do
      expr = parse_expression("-42;")
      expect(expr).to be_a(UnaryExpr)
      expect(expr.operator.type).to eq(TokenType::MINUS)
      expect(expr.right).to be_a(LiteralExpr)

      expr = parse_expression("!true;")
      expect(expr).to be_a(UnaryExpr)
      expect(expr.operator.type).to eq(TokenType::BANG)
    end

    it "parses grouping expressions" do
      expr = parse_expression("(1 + 2);")
      expect(expr).to be_a(GroupingExpr)
      expect(expr.expression).to be_a(BinaryExpr)
    end

    it "respects operator precedence" do
      # 1 + 2 * 3 should parse as 1 + (2 * 3)
      expr = parse_expression("1 + 2 * 3;")
      expect(expr).to be_a(BinaryExpr)
      expect(expr.operator.type).to eq(TokenType::PLUS)
      expect(expr.left).to be_a(LiteralExpr)
      expect(expr.right).to be_a(BinaryExpr)
      expect(expr.right.operator.type).to eq(TokenType::STAR)
    end

    it "parses variable declarations" do
      source = "var x = 42;"
      scanner = Scanner.new(source)
      tokens = scanner.scan_tokens
      parser = Parser.new(tokens)
      statements = parser.parse

      expect(statements.first).to be_a(VarStmt)
      expect(statements.first.name.lexeme).to eq("x")
      expect(statements.first.initializer).to be_a(LiteralExpr)
    end

    it "parses print statements" do
      source = 'print "hello";'
      scanner = Scanner.new(source)
      tokens = scanner.scan_tokens
      parser = Parser.new(tokens)
      statements = parser.parse

      expect(statements.first).to be_a(PrintStmt)
      expect(statements.first.expression).to be_a(LiteralExpr)
    end

    it "parses function declarations" do
      source = "fun add(a, b) { return a + b; }"
      scanner = Scanner.new(source)
      tokens = scanner.scan_tokens
      parser = Parser.new(tokens)
      statements = parser.parse

      expect(statements.first).to be_a(FunctionStmt)
      expect(statements.first.name.lexeme).to eq("add")
      expect(statements.first.params.length).to eq(2)
      expect(statements.first.params[0].lexeme).to eq("a")
      expect(statements.first.params[1].lexeme).to eq("b")
    end

    it "parses if statements" do
      source = "if (true) print 1; else print 2;"
      scanner = Scanner.new(source)
      tokens = scanner.scan_tokens
      parser = Parser.new(tokens)
      statements = parser.parse

      expect(statements.first).to be_a(IfStmt)
      expect(statements.first.condition).to be_a(LiteralExpr)
      expect(statements.first.then_branch).to be_a(PrintStmt)
      expect(statements.first.else_branch).to be_a(PrintStmt)
    end

    it "parses while statements" do
      source = "while (true) print 1;"
      scanner = Scanner.new(source)
      tokens = scanner.scan_tokens
      parser = Parser.new(tokens)
      statements = parser.parse

      expect(statements.first).to be_a(WhileStmt)
      expect(statements.first.condition).to be_a(LiteralExpr)
      expect(statements.first.body).to be_a(PrintStmt)
    end
  end
end