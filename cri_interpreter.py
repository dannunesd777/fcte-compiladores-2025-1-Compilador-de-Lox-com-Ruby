"""
CRi Language Interpreter
=========================

Interpreter for the CRi programming language.
Evaluates the Abstract Syntax Tree (AST) and executes the program.
"""

from cri_parser import ASTNode, NumberNode, BinaryOpNode, UnaryOpNode, PrintNode, ProgramNode


class CRiInterpreter:
    """Interpreter for CRi language"""
    
    def __init__(self):
        self.output = []  # Store output for testing
    
    def interpret(self, ast: ProgramNode):
        """Interpret the AST and execute the program"""
        for statement in ast.statements:
            self._evaluate(statement)
    
    def _evaluate(self, node: ASTNode):
        """Evaluate an AST node"""
        if isinstance(node, NumberNode):
            return node.value
        
        elif isinstance(node, BinaryOpNode):
            left = self._evaluate(node.left)
            right = self._evaluate(node.right)
            
            if node.operator == '+':
                return left + right
            elif node.operator == '-':
                return left - right
            elif node.operator == '*':
                return left * right
            elif node.operator == '/':
                if right == 0:
                    raise RuntimeError("Division by zero")
                return left / right
            elif node.operator == '^':
                return left ** right
            else:
                raise RuntimeError(f"Unknown binary operator: {node.operator}")
        
        elif isinstance(node, UnaryOpNode):
            operand = self._evaluate(node.operand)
            
            if node.operator == '+':
                return +operand
            elif node.operator == '-':
                return -operand
            else:
                raise RuntimeError(f"Unknown unary operator: {node.operator}")
        
        elif isinstance(node, PrintNode):
            value = self._evaluate(node.expression)
            output = str(value)
            print(output)
            self.output.append(output)
            return value
        
        else:
            raise RuntimeError(f"Unknown AST node type: {type(node)}")
    
    def get_output(self) -> list:
        """Get captured output (for testing)"""
        return self.output.copy()
    
    def clear_output(self):
        """Clear captured output"""
        self.output.clear()