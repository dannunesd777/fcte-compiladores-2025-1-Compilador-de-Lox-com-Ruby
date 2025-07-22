"""
Testes para o interpretador CRi
=================================

Testes unitários básicos para validar as funcionalidades da linguagem CRi.
"""

import unittest
import sys
import os

# Adicionar o diretório atual ao path para imports
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from cri_lexer import CRiLexer, TokenType
from cri_parser import CRiParser
from cri_interpreter import CRiInterpreter


class TestCRiLexer(unittest.TestCase):
    """Testes para o analisador léxico"""
    
    def test_basic_tokens(self):
        lexer = CRiLexer("2 + 3")
        tokens = lexer.tokenize()
        
        self.assertEqual(len(tokens), 4)  # NUMBER, PLUS, NUMBER, EOF
        self.assertEqual(tokens[0].type, TokenType.NUMBER)
        self.assertEqual(tokens[0].value, "2")
        self.assertEqual(tokens[1].type, TokenType.PLUS)
        self.assertEqual(tokens[2].type, TokenType.NUMBER)
        self.assertEqual(tokens[2].value, "3")
        self.assertEqual(tokens[3].type, TokenType.EOF)
    
    def test_all_operators(self):
        lexer = CRiLexer("+ - * / ^")
        tokens = lexer.tokenize()
        
        expected_types = [TokenType.PLUS, TokenType.MINUS, TokenType.MULTIPLY, 
                         TokenType.DIVIDE, TokenType.POWER, TokenType.EOF]
        actual_types = [token.type for token in tokens]
        self.assertEqual(actual_types, expected_types)
    
    def test_print_statement(self):
        lexer = CRiLexer("print 42")
        tokens = lexer.tokenize()
        
        self.assertEqual(tokens[0].type, TokenType.PRINT)
        self.assertEqual(tokens[1].type, TokenType.NUMBER)
        self.assertEqual(tokens[1].value, "42")
    
    def test_comments(self):
        lexer = CRiLexer("# comentário\nprint 42")
        tokens = lexer.tokenize()
        
        # Comentários devem ser filtrados
        self.assertEqual(tokens[0].type, TokenType.NEWLINE)
        self.assertEqual(tokens[1].type, TokenType.PRINT)
        self.assertEqual(tokens[2].type, TokenType.NUMBER)


class TestCRiParser(unittest.TestCase):
    """Testes para o analisador sintático"""
    
    def test_simple_expression(self):
        lexer = CRiLexer("2 + 3")
        tokens = lexer.tokenize()
        parser = CRiParser(tokens)
        ast = parser.parse()
        
        self.assertEqual(len(ast.statements), 1)
        stmt = ast.statements[0]
        self.assertEqual(stmt.operator, "+")
        self.assertEqual(stmt.left.value, 2.0)
        self.assertEqual(stmt.right.value, 3.0)
    
    def test_operator_precedence(self):
        lexer = CRiLexer("2 + 3 * 4")
        tokens = lexer.tokenize()
        parser = CRiParser(tokens)
        ast = parser.parse()
        
        stmt = ast.statements[0]
        self.assertEqual(stmt.operator, "+")
        self.assertEqual(stmt.left.value, 2.0)
        # O lado direito deve ser uma multiplicação
        self.assertEqual(stmt.right.operator, "*")
        self.assertEqual(stmt.right.left.value, 3.0)
        self.assertEqual(stmt.right.right.value, 4.0)


class TestCRiInterpreter(unittest.TestCase):
    """Testes para o interpretador"""
    
    def test_basic_arithmetic(self):
        interpreter = CRiInterpreter()
        
        # Teste de soma
        lexer = CRiLexer("2 + 3")
        tokens = lexer.tokenize()
        parser = CRiParser(tokens)
        ast = parser.parse()
        
        result = interpreter._evaluate(ast.statements[0])
        self.assertEqual(result, 5.0)
    
    def test_all_operations(self):
        interpreter = CRiInterpreter()
        
        test_cases = [
            ("5 + 3", 8.0),
            ("10 - 4", 6.0),
            ("6 * 7", 42.0),
            ("15 / 3", 5.0),
            ("2 ^ 3", 8.0),
        ]
        
        for source, expected in test_cases:
            lexer = CRiLexer(source)
            tokens = lexer.tokenize()
            parser = CRiParser(tokens)
            ast = parser.parse()
            
            result = interpreter._evaluate(ast.statements[0])
            self.assertEqual(result, expected, f"Failed for: {source}")
    
    def test_print_statement(self):
        interpreter = CRiInterpreter()
        
        lexer = CRiLexer("print 42")
        tokens = lexer.tokenize()
        parser = CRiParser(tokens)
        ast = parser.parse()
        
        interpreter.interpret(ast)
        output = interpreter.get_output()
        self.assertEqual(output, ["42.0"])
    
    def test_complex_expression(self):
        interpreter = CRiInterpreter()
        
        lexer = CRiLexer("(2 + 3) * 4")
        tokens = lexer.tokenize()
        parser = CRiParser(tokens)
        ast = parser.parse()
        
        result = interpreter._evaluate(ast.statements[0])
        self.assertEqual(result, 20.0)
    
    def test_unary_operations(self):
        interpreter = CRiInterpreter()
        
        test_cases = [
            ("+42", 42.0),
            ("-42", -42.0),
            ("-(2 + 3)", -5.0),
        ]
        
        for source, expected in test_cases:
            lexer = CRiLexer(source)
            tokens = lexer.tokenize()
            parser = CRiParser(tokens)
            ast = parser.parse()
            
            result = interpreter._evaluate(ast.statements[0])
            self.assertEqual(result, expected, f"Failed for: {source}")


if __name__ == "__main__":
    unittest.main()