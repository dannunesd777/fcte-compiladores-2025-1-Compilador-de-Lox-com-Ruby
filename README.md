


## Escopo e Organização

Este projeto foi desenvolvido como trabalho da disciplina de Compiladores, atendendo ao escopo de implementar um **interpretador completo para uma linguagem de programação simples** (Lox). O objetivo é exercitar as etapas clássicas de construção de linguagens: análise léxica, sintática, semântica e execução, além de demonstrar organização modular, exemplos didáticos e testes automatizados. O repositório está estruturado conforme as orientações da disciplina, com README detalhado, exemplos variados, referências, estrutura de código clara e documentação de bugs/limitações.

# Interpretador da Linguagem Lox em Ruby

## 🧑‍🎓Integrantes
|         Nome          | Matrícula   |     Turma     |
|-----------------------|-------------|---------------|
|  Daniel Nunes Duarte  |   211062910 |  Turma 1-16h  |
| Gabriel Augusto V. V. Rocha | 221022533 | Turma 3-18h |


## Introdução

Este projeto implementa um interpretador completo para a linguagem de programação Lox usando Ruby. Lox é uma linguagem dinâmica e de alto nível criada por Robert Nystrom em seu livro "Crafting Interpreters". 

### Características da Linguagem Lox

A linguagem Lox implementada neste projeto possui as seguintes características:

- **Tipagem dinâmica**: Variáveis não precisam de declaração de tipo
- **Tipos de dados básicos**: números (inteiros e floats), strings, booleanos (true/false) e nil
- **Variáveis**: Declaração com `var` e atribuição com `=`
- **Expressões aritméticas**: +, -, *, / com precedência adequada
- **Expressões lógicas**: and, or, ! (not)
- **Expressões de comparação**: ==, !=, <, <=, >, >=
- **Estruturas de controle**: if/else, while, for
- **Funções**: Declaração com `fun`, parâmetros, valores de retorno
- **Escopo de variáveis**: Escopo léxico com ambientes aninhados
- **Recursão**: Suporte completo a funções recursivas
- **Funções built-in**: `clock()` para timestamp, `pi()` para PI, `abs()` para valor absoluto

### Exemplos de Sintaxe

**Variáveis e Expressões:**
```lox
var nome = "Lox";
var idade = 25;
var ativo = true;
```

**Estruturas de Controle:**
```lox
if (idade >= 18) {
    print "Maior de idade";
} else {
    print "Menor de idade";
}

for (var i = 0; i < 10; i = i + 1) {
    print i;
}
```

**Funções:**
```lox
fun fibonacci(n) {
    if (n <= 1) {
        return n;
    }
    return fibonacci(n - 1) + fibonacci(n - 2);
}
```

### Estratégias e Algoritmos Implementados

O interpretador utiliza as técnicas clássicas de implementação de linguagens:

1. **Análise Léxica (Scanner)**: Converte código fonte em tokens usando autômato finito
2. **Análise Sintática (Parser)**: Constrói Árvore Sintática Abstrata (AST) usando recursive descent parsing
3. **Interpretação (Tree-walking Interpreter)**: Executa a AST usando o padrão Visitor
4. **Gerenciamento de Ambiente**: Implementa escopo léxico com ambientes aninhados

## Como Rodar

1. **Pré-requisito:** Ruby >= 3.0.0 instalado na máquina.
2. **Instale as dependências (opcional, para desenvolvimento):**
   ```bash
   bundle install
   ```
3. **Execute um exemplo:**
   ```bash
   ruby lox.rb exemplos/hello.lox
   ```
   Ou rode qualquer outro exemplo da pasta `exemplos/`:
   ```bash
   ruby lox.rb exemplos/fibonacci.lox
   ruby lox.rb exemplos/algoritmos.lox
   ruby lox.rb exemplos/abs.lox
   # ...
   ```
4. **REPL interativo:**
   ```bash
   ruby lox.rb
   ```

## Como Rodar os Testes

O projeto possui testes automatizados de unidade e integração utilizando RSpec. Para rodar todos os testes:

1. Certifique-se de ter instalado as dependências de desenvolvimento:
   ```bash
   bundle install
   ```
2. Execute:
   ```bash
   rspec
   ```

Os testes estão localizados na pasta `spec/` e cobrem análise léxica, sintática e integração do interpretador.

## Instalação

### Pré-requisitos
- Ruby >= 3.0.0

### Passos para instalação

1. Clone o repositório:
```bash
git clone [URL_DO_REPOSITORIO]
cd fcte-compiladores-2025-1-trabalho-final-trabalho-f
```

2. Instale as dependências (opcional, para desenvolvimento):
```bash
bundle install
```

3. Execute o interpretador:
```bash
# Executar um arquivo Lox
ruby lox.rb exemplos/hello.lox

# Ou executar o REPL interativo
ruby lox.rb
```

## Exemplos

O projeto inclui uma pasta `exemplos/` com programas Lox de complexidade crescente:

### 1. Hello World (`hello.lox`)
```bash
ruby lox.rb exemplos/hello.lox
```
Demonstra saída básica com `print`.

### 2. Variáveis e Operações (`variaveis.lox`)
```bash
ruby lox.rb exemplos/variaveis.lox
```
Demonstra declaração de variáveis, operações aritméticas, lógicas e comparações.

### 3. Estruturas de Controle (`controle.lox`)
```bash
ruby lox.rb exemplos/controle.lox
```
Demonstra if/else, while, for e operadores lógicos.

### 4. Funções (`funcoes.lox`)
```bash
ruby lox.rb exemplos/funcoes.lox
```
Demonstra definição de funções, parâmetros, valores de retorno e escopo de variáveis.

### 5. Recursão - Fibonacci (`fibonacci.lox`)
```bash
ruby lox.rb exemplos/fibonacci.lox
```
Implementa funções recursivas para calcular Fibonacci e fatorial.


### 6. Algoritmos Avançados (`algoritmos.lox`)
```bash
ruby lox.rb exemplos/algoritmos.lox
```
Implementa algoritmos mais complexos como ordenação (bubble sort conceitual) e busca binária.

### 7. Tipos e Concatenação (`tipos.lox`)
```bash
ruby lox.rb exemplos/tipos.lox
```
Mostra uso de inteiros, floats, booleanos e concatenação de strings.


### 8. Funções Nativas (`nativos.lox`)
```bash
ruby lox.rb exemplos/nativos.lox
```
Demonstra uso das funções nativas `clock()`, `pi()` e outras.

### 9. Valor Absoluto (`abs.lox`)
```bash
ruby lox.rb exemplos/abs.lox
```
Exemplo de uso da função nativa `abs()` para valor absoluto de inteiros e floats.

### 10. Erros em Tempo de Execução (`erros.lox`)
```bash
ruby lox.rb exemplos/erros.lox
```
Exemplos de erros: divisão por zero e operação inválida entre tipos.

## Referências

1. **Nystrom, Robert.** "Crafting Interpreters". Disponível em: https://craftinginterpreters.com/
   - **Uso**: Referência principal para a arquitetura do interpretador, gramática da linguagem Lox e técnicas de implementação. A estrutura geral do código segue os padrões estabelecidos no livro.

2. **Aho, Alfred V.; Sethi, Ravi; Ullman, Jeffrey D.** "Compilers: Principles, Techniques, and Tools" (Dragon Book)
   - **Uso**: Referência para técnicas de análise léxica e sintática, especialmente para o design do scanner e parser recursive descent.

3. **Documentação Ruby.** Disponível em: https://ruby-doc.org/
   - **Uso**: Referência para recursos específicos do Ruby utilizados na implementação, como classes, módulos e tratamento de exceções.

### Contribuições Originais

- **Implementação completa em Ruby**: Adaptação da arquitetura Lox para idiomas Ruby
- **Sistema de concatenação flexível**: Extensão do operador + para permitir concatenação automática entre strings e outros tipos
- **Estrutura de arquivos modular**: Organização do código em módulos separados para facilitar manutenção
- **Exemplos didáticos**: Criação de exemplos progressivos demonstrando diferentes aspectos da linguagem

## Estrutura do Código

O projeto está organizado nos seguintes módulos principais:

### `/lox.rb`
**Ponto de entrada principal** do interpretador. Gerencia:
- Interface de linha de comando (arquivo ou REPL)
- Coordenação entre as fases de compilação
- Tratamento de erros globais
- Classe `Lox` com métodos estáticos para controle do interpretador

### `/lib/token.rb`
**Definições de tokens** e tipos:
- Módulo `TokenType` com todos os tipos de tokens da linguagem
- Classe `Token` representando um token individual com tipo, lexema, literal e linha

### `/lib/scanner.rb`
**Análise Léxica (Scanner)**:
- Classe `Scanner` que implementa o analisador léxico
- Converte código fonte em sequência de tokens
- Reconhece palavras-chave, identificadores, números, strings e operadores
- Gerencia comentários e whitespace
- **Fase**: Análise Léxica

### `/lib/ast.rb`
**Definições da AST (Abstract Syntax Tree)**:
- Classes para nós de expressão: `BinaryExpr`, `UnaryExpr`, `LiteralExpr`, `VariableExpr`, etc.
- Classes para nós de declaração: `ExpressionStmt`, `PrintStmt`, `VarStmt`, `FunctionStmt`, etc.
- Implementa padrão Visitor para percorrer a árvore

### `/lib/parser.rb`
**Análise Sintática (Parser)**:
- Classe `Parser` que implementa parser recursive descent
- Constrói AST a partir da sequência de tokens
- Implementa precedência de operadores e associatividade
- Gerencia sincronização em caso de erros sintáticos
- **Fase**: Análise Sintática

### `/lib/environment.rb`
**Gerenciamento de Escopo**:
- Classe `Environment` para armazenamento de variáveis
- Implementa escopo léxico com ambientes aninhados
- Suporte a definição, acesso e atribuição de variáveis

### `/lib/interpreter.rb`
**Interpretação e Execução**:
- Classe `Interpreter` que implementa tree-walking interpreter
- Classe `LoxFunction` para funções definidas pelo usuário
- Classe `LoxCallable` interface para objetos chamáveis
- Executa AST usando padrão Visitor
- Gerencia chamadas de função e valores de retorno
- **Fase**: Interpretação/Execução

### `/exemplos/`
**Programas de exemplo** organizados por complexidade crescente, demonstrando diferentes aspectos da linguagem.

### Fluxo de Execução

1. **Leitura**: `lox.rb` lê arquivo fonte ou entrada do usuário
2. **Análise Léxica**: `Scanner` converte código em tokens
3. **Análise Sintática**: `Parser` constrói AST a partir dos tokens
4. **Interpretação**: `Interpreter` executa a AST usando tree-walking

## Bugs/Limitações/Problemas Conhecidos

### Limitações da Implementação Atual

1. **Ausência de Classes**: A implementação atual não suporta classes e herança, que são características da linguagem Lox completa
2. **Sem Arrays/Listas**: Não há suporte a estruturas de dados compostas como arrays ou mapas
3. **Tratamento de Erros Básico**: O sistema de erros é funcional mas poderia ser mais detalhado com melhor localização de erros
4. **Performance**: Por ser um tree-walking interpreter, a performance é limitada comparada a bytecode interpreters ou compiladores
5. **Sem Garbage Collection**: Ruby gerencia memória automaticamente, mas o design não considera otimizações específicas para Lox

### Melhorias Incrementais Possíveis

1. **Implementar Classes**: Adicionar suporte completo a classes, métodos e herança
2. **Estruturas de Dados**: Implementar arrays, maps e outras estruturas de dados básicas
3. **Melhor Tratamento de Erros**: Adicionar source locations mais precisos e mensagens de erro mais informativas
4. **Otimizações**: Implementar constant folding e outras otimizações simples
5. **Debugging**: Adicionar suporte a breakpoints e step-through debugging
6. **Standard Library**: Expandir biblioteca padrão com mais funções úteis (math, string manipulation, I/O)
7. **Testes Automatizados**: Adicionar suite completa de testes unitários e de integração

### Problemas Conhecidos

**[Resolvidos]**
1. **Concatenação de Strings**: Agora só é permitida concatenação automática se ambos os operandos forem strings, ou ambos números. Se um for string e outro não, será feita conversão explícita, evitando mascarar erros de tipo.
2. **Validação de Overflow**: Soma, subtração, multiplicação e divisão agora verificam overflow e resultados inválidos (infinito ou NaN), lançando erro apropriado.
3. **REPL Aprimorado**: O REPL agora aceita múltiplas linhas e só executa o código ao pressionar Enter duas vezes, permitindo declarações multi-linha e mantendo o estado entre comandos.


# 🚦 Status do Projeto

✔️ Interpretador funcional e testado
✔️ Todos os exemplos da pasta `exemplos/` executam corretamente
✔️ Testes unitários e de integração (RSpec) passam sem falhas
✔️ Modularização e documentação completas

---
