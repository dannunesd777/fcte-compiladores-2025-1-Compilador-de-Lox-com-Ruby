"""
CRi Language Lexer
==================

Lexical analyzer for the CRi programming language.
Converts source code into tokens for parsing.
"""

import re
from enum import Enum, auto
from dataclasses import dataclass
from typing import List, Optional


class TokenType(Enum):
    # Literals
    NUMBER = auto()
    
    # Operators
    PLUS = auto()
    MINUS = auto()
    MULTIPLY = auto()
    DIVIDE = auto()
    POWER = auto()
    
    # Delimiters
    LPAREN = auto()
    RPAREN = auto()
    
    # Keywords
    PRINT = auto()
    
    # Special
    NEWLINE = auto()
    EOF = auto()
    WHITESPACE = auto()
    COMMENT = auto()


@dataclass
class Token:
    type: TokenType
    value: str
    line: int
    column: int


class CRiLexer:
    """Lexical analyzer for CRi language"""
    
    def __init__(self, source: str):
        self.source = source
        self.position = 0
        self.line = 1
        self.column = 1
        self.tokens = []
        
        # Token patterns
        self.token_patterns = [
            (r'#.*', TokenType.COMMENT),
            (r'\d+(\.\d+)?', TokenType.NUMBER),
            (r'\+', TokenType.PLUS),
            (r'-', TokenType.MINUS),
            (r'\*', TokenType.MULTIPLY),
            (r'/', TokenType.DIVIDE),
            (r'\^', TokenType.POWER),
            (r'\(', TokenType.LPAREN),
            (r'\)', TokenType.RPAREN),
            (r'print\b', TokenType.PRINT),
            (r'\n', TokenType.NEWLINE),
            (r'[ \t]+', TokenType.WHITESPACE),
        ]
    
    def tokenize(self) -> List[Token]:
        """Convert source code into list of tokens"""
        self.tokens = []
        
        while self.position < len(self.source):
            if self._match_token():
                continue
            else:
                raise SyntaxError(f"Unexpected character '{self.source[self.position]}' at line {self.line}, column {self.column}")
        
        # Add EOF token
        self.tokens.append(Token(TokenType.EOF, "", self.line, self.column))
        
        # Filter out whitespace and comment tokens
        return [token for token in self.tokens if token.type not in [TokenType.WHITESPACE, TokenType.COMMENT]]
    
    def _match_token(self) -> bool:
        """Try to match a token at current position"""
        for pattern, token_type in self.token_patterns:
            regex = re.compile(pattern)
            match = regex.match(self.source, self.position)
            
            if match:
                value = match.group(0)
                token = Token(token_type, value, self.line, self.column)
                self.tokens.append(token)
                
                # Update position
                self.position = match.end()
                
                # Update line and column
                if token_type == TokenType.NEWLINE:
                    self.line += 1
                    self.column = 1
                else:
                    self.column += len(value)
                
                return True
        
        return False