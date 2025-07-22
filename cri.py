#!/usr/bin/env python3
"""
CRi Language Main Module
========================

Command-line interface for the CRi programming language interpreter.
"""

import sys
import argparse
from pathlib import Path

from cri_lexer import CRiLexer
from cri_parser import CRiParser
from cri_interpreter import CRiInterpreter


def run_file(filename: str):
    """Run a CRi program from a file"""
    try:
        with open(filename, 'r') as file:
            source = file.read()
        
        run_source(source)
    
    except FileNotFoundError:
        print(f"Error: File '{filename}' not found.", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


def run_source(source: str):
    """Run CRi source code"""
    try:
        # Lexical analysis
        lexer = CRiLexer(source)
        tokens = lexer.tokenize()
        
        # Syntax analysis
        parser = CRiParser(tokens)
        ast = parser.parse()
        
        # Interpretation
        interpreter = CRiInterpreter()
        interpreter.interpret(ast)
    
    except (SyntaxError, RuntimeError) as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


def run_repl():
    """Run CRi in interactive mode (REPL)"""
    print("CRi Language Interpreter v1.0")
    print("Type 'exit' to quit.")
    print()
    
    interpreter = CRiInterpreter()
    
    while True:
        try:
            source = input("cri> ")
            
            if source.strip().lower() == 'exit':
                break
            
            if source.strip() == '':
                continue
            
            # Lexical analysis
            lexer = CRiLexer(source)
            tokens = lexer.tokenize()
            
            # Syntax analysis
            parser = CRiParser(tokens)
            ast = parser.parse()
            
            # Interpretation
            interpreter.interpret(ast)
        
        except (SyntaxError, RuntimeError) as e:
            print(f"Error: {e}")
        except KeyboardInterrupt:
            print("\nGoodbye!")
            break
        except EOFError:
            print("\nGoodbye!")
            break


def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(
        description="CRi Language Interpreter",
        epilog="If no file is provided, starts interactive mode (REPL)."
    )
    parser.add_argument(
        "file", 
        nargs="?", 
        help="CRi source file to execute"
    )
    
    args = parser.parse_args()
    
    if args.file:
        run_file(args.file)
    else:
        run_repl()


if __name__ == "__main__":
    main()