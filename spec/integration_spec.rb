# Garantir que funções nativas estejam disponíveis
require_relative "../lib/abs_function"
# frozen_string_literal: true

require_relative "../lox"

RSpec.describe "Lox Integration" do
  def run_lox(source)
    # Suppress error output during tests
    allow(Lox).to receive(:error)
    allow(Lox).to receive(:runtime_error)
    
    # Capture stdout
    original_stdout = $stdout
    captured_output = StringIO.new
    $stdout = captured_output

    begin
      Lox.send(:run, source)
      captured_output.string
    ensure
      $stdout = original_stdout
    end
  end

  describe "arithmetic operations" do
    it "evaluates addition" do
      output = run_lox("print 1 + 2;")
      expect(output.strip).to eq("3")
    end

    it "evaluates subtraction" do
      output = run_lox("print 5 - 3;")
      expect(output.strip).to eq("2")
    end

    it "evaluates multiplication" do
      output = run_lox("print 4 * 3;")
      expect(output.strip).to eq("12")
    end

    it "evaluates division" do
      output = run_lox("print 6 / 2;")
      expect(output.strip).to eq("3")
    end

    it "respects operator precedence" do
      output = run_lox("print 1 + 2 * 3;")
      expect(output.strip).to eq("7")
    end
  end

  describe "string operations" do
    it "concatenates strings" do
      output = run_lox('print "Hello, " + "World!";')
      expect(output.strip).to eq("Hello, World!")
    end

    it "concatenates string with number" do
      output = run_lox('print "Number: " + 42;')
      expect(output.strip).to eq("Number: 42")
    end
  end

  describe "variables" do
    it "declares and uses variables" do
      source = <<~LOX
        var x = 10;
        var y = 20;
        print x + y;
      LOX
      output = run_lox(source)
      expect(output.strip).to eq("30")
    end

    it "assigns to existing variables" do
      source = <<~LOX
        var x = 10;
        x = 20;
        print x;
      LOX
      output = run_lox(source)
      expect(output.strip).to eq("20")
    end
  end

  describe "control flow" do
    it "executes if statement" do
      source = <<~LOX
        if (true) {
          print "executed";
        }
      LOX
      output = run_lox(source)
      expect(output.strip).to eq("executed")
    end

    it "executes else branch" do
      source = <<~LOX
        if (false) {
          print "not executed";
        } else {
          print "executed";
        }
      LOX
      output = run_lox(source)
      expect(output.strip).to eq("executed")
    end

    it "executes while loop" do
      source = <<~LOX
        var i = 0;
        while (i < 3) {
          print i;
          i = i + 1;
        }
      LOX
      output = run_lox(source)
      expect(output.strip).to eq("0\n1\n2")
    end
  end

  describe "functions" do
    it "defines and calls functions" do
      source = <<~LOX
        fun greet(name) {
          return "Hello, " + name + "!";
        }
        print greet("Alice");
      LOX
      output = run_lox(source)
      expect(output.strip).to eq("Hello, Alice!")
    end

    it "handles recursive functions" do
      source = <<~LOX
        fun factorial(n) {
          if (n <= 1) {
            return 1;
          }
          return n * factorial(n - 1);
        }
        print factorial(5);
      LOX
      output = run_lox(source)
      expect(output.strip).to eq("120")
    end

    it "handles functions with no return value" do
      source = <<~LOX
        fun sayHello() {
          print "Hello!";
        }
        sayHello();
      LOX
      output = run_lox(source)
      expect(output.strip).to eq("Hello!")
    end
  end

  describe "scoping" do
    it "handles local variable scoping" do
      source = <<~LOX
        var global = "global";
        {
          var local = "local";
          print local;
          print global;
        }
        print global;
      LOX
      output = run_lox(source)
      expect(output.strip).to eq("local\nglobal\nglobal")
    end

    it "handles function parameter scoping" do
      source = <<~LOX
        var x = "global";
        fun test(x) {
          print x;
        }
        test("parameter");
        print x;
      LOX
      output = run_lox(source)
      expect(output.strip).to eq("parameter\nglobal")
    end
  end

  describe "logical operations" do
    it "evaluates and operator" do
      output = run_lox("print true and false;")
      expect(output.strip).to eq("false")

      output = run_lox("print true and true;")
      expect(output.strip).to eq("true")
    end

    it "evaluates or operator" do
      output = run_lox("print false or true;")
      expect(output.strip).to eq("true")

      output = run_lox("print false or false;")
      expect(output.strip).to eq("false")
    end

    it "short-circuits logical operators" do
      source = <<~LOX
        fun side_effect() {
          print "side effect";
          return true;
        }
        print false and side_effect();
      LOX
      output = run_lox(source)
      expect(output.strip).to eq("false")  # Should not print "side effect"
    end
  end
end