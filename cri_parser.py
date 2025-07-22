"""
CRi Language Parser
===================

Syntax analyzer for the CRi programming language.
Converts tokens into an Abstract Syntax Tree (AST).
"""

from typing import List, Union, Optional
from cri_lexer import Token, TokenType


class ASTNode:
    """Base class for all AST nodes"""
    pass


class NumberNode(ASTNode):
    def __init__(self, value: float):
        self.value = value
    
    def __repr__(self):
        return f"NumberNode({self.value})"


class BinaryOpNode(ASTNode):
    def __init__(self, left: ASTNode, operator: str, right: ASTNode):
        self.left = left
        self.operator = operator
        self.right = right
    
    def __repr__(self):
        return f"BinaryOpNode({self.left}, '{self.operator}', {self.right})"


class UnaryOpNode(ASTNode):
    def __init__(self, operator: str, operand: ASTNode):
        self.operator = operator
        self.operand = operand
    
    def __repr__(self):
        return f"UnaryOpNode('{self.operator}', {self.operand})"


class PrintNode(ASTNode):
    def __init__(self, expression: ASTNode):
        self.expression = expression
    
    def __repr__(self):
        return f"PrintNode({self.expression})"


class ProgramNode(ASTNode):
    def __init__(self, statements: List[ASTNode]):
        self.statements = statements
    
    def __repr__(self):
        return f"ProgramNode({self.statements})"


class CRiParser:
    """Recursive descent parser for CRi language"""
    
    def __init__(self, tokens: List[Token]):
        self.tokens = tokens
        self.position = 0
        self.current_token = self.tokens[0] if tokens else None
    
    def parse(self) -> ProgramNode:
        """Parse tokens into AST"""
        statements = []
        
        while not self._is_at_end():
            if self.current_token.type == TokenType.NEWLINE:
                self._advance()
                continue
            
            stmt = self._statement()
            if stmt:
                statements.append(stmt)
        
        return ProgramNode(statements)
    
    def _statement(self) -> Optional[ASTNode]:
        """Parse a statement"""
        if self.current_token.type == TokenType.PRINT:
            return self._print_statement()
        else:
            return self._expression_statement()
    
    def _print_statement(self) -> PrintNode:
        """Parse print statement: print <expression>"""
        self._consume(TokenType.PRINT, "Expected 'print'")
        expr = self._expression()
        return PrintNode(expr)
    
    def _expression_statement(self) -> ASTNode:
        """Parse expression statement"""
        return self._expression()
    
    def _expression(self) -> ASTNode:
        """Parse expression with operator precedence"""
        return self._addition()
    
    def _addition(self) -> ASTNode:
        """Parse addition and subtraction (lowest precedence)"""
        expr = self._multiplication()
        
        while self.current_token.type in [TokenType.PLUS, TokenType.MINUS]:
            operator = self.current_token.value
            self._advance()
            right = self._multiplication()
            expr = BinaryOpNode(expr, operator, right)
        
        return expr
    
    def _multiplication(self) -> ASTNode:
        """Parse multiplication and division"""
        expr = self._power()
        
        while self.current_token.type in [TokenType.MULTIPLY, TokenType.DIVIDE]:
            operator = self.current_token.value
            self._advance()
            right = self._power()
            expr = BinaryOpNode(expr, operator, right)
        
        return expr
    
    def _power(self) -> ASTNode:
        """Parse exponentiation (highest precedence)"""
        expr = self._unary()
        
        if self.current_token.type == TokenType.POWER:
            operator = self.current_token.value
            self._advance()
            right = self._power()  # Right associative
            expr = BinaryOpNode(expr, operator, right)
        
        return expr
    
    def _unary(self) -> ASTNode:
        """Parse unary expressions"""
        if self.current_token.type in [TokenType.PLUS, TokenType.MINUS]:
            operator = self.current_token.value
            self._advance()
            expr = self._unary()
            return UnaryOpNode(operator, expr)
        
        return self._primary()
    
    def _primary(self) -> ASTNode:
        """Parse primary expressions (numbers and parentheses)"""
        if self.current_token.type == TokenType.NUMBER:
            value = float(self.current_token.value)
            self._advance()
            return NumberNode(value)
        
        if self.current_token.type == TokenType.LPAREN:
            self._advance()  # consume '('
            expr = self._expression()
            self._consume(TokenType.RPAREN, "Expected ')' after expression")
            return expr
        
        raise SyntaxError(f"Unexpected token: {self.current_token.value} at line {self.current_token.line}")
    
    def _advance(self):
        """Move to next token"""
        if not self._is_at_end():
            self.position += 1
            if self.position < len(self.tokens):
                self.current_token = self.tokens[self.position]
    
    def _is_at_end(self) -> bool:
        """Check if we're at end of tokens"""
        return self.current_token.type == TokenType.EOF
    
    def _consume(self, token_type: TokenType, message: str):
        """Consume expected token or raise error"""
        if self.current_token.type == token_type:
            self._advance()
        else:
            raise SyntaxError(f"{message}. Got {self.current_token.value} at line {self.current_token.line}")