# CRi - Calculadora e Interpretador Simples

## Integrantes

- Nome: [A ser preenchido pelo usuário]
- Matrícula: [A ser preenchido pelo usuário]  
- Turma: [A ser preenchido pelo usuário]

## Introdução

CRi é uma linguagem de programação simples focada em expressões aritméticas e cálculos matemáticos. O projeto implementa um interpretador completo para a linguagem CRi, que inclui analisador léxico, sintático e um interpretador que executa as operações.

### Características da Linguagem CRi

A linguagem CRi suporta:

- **Números**: Inteiros e decimais (exemplo: `42`, `3.14`)
- **Operadores aritméticos**: 
  - Soma (`+`)
  - Subtração (`-`)
  - Multiplicação (`*`)
  - Divisão (`/`)
  - Potenciação (`^`)
- **Operadores unários**: `+` e `-` (exemplo: `-42`, `+3.14`)
- **Parênteses**: Para controle de precedência (exemplo: `(2 + 3) * 4`)
- **Comando print**: Para exibir resultados (exemplo: `print 2 + 3`)
- **Comentários**: Linhas iniciadas com `#` são ignoradas

### Sintaxe e Semântica

```
programa ::= declaracao*
declaracao ::= comando_print | expressao
comando_print ::= "print" expressao
expressao ::= adicao
adicao ::= multiplicacao (('+' | '-') multiplicacao)*
multiplicacao ::= potencia (('*' | '/') potencia)*
potencia ::= unario ('^' potencia)?
unario ::= ('+' | '-') unario | primaria
primaria ::= NUMERO | '(' expressao ')'
```

A precedência dos operadores (do menor para o maior):
1. Adição e subtração (`+`, `-`)
2. Multiplicação e divisão (`*`, `/`)
3. Potenciação (`^`) - associativa à direita
4. Operadores unários (`+`, `-`)

### Exemplos de Uso

```cri
# Operações básicas
print 2 + 3        # Resultado: 5.0
print 10 * 4       # Resultado: 40.0
print 2 ^ 3        # Resultado: 8.0

# Expressões complexas
print (2 + 3) * 4  # Resultado: 20.0
print -2 + 3       # Resultado: 1.0
```

## Instalação

### Pré-requisitos

- Python 3.6 ou superior

### Instalação das dependências

```bash
# Não há dependências externas
# CRi utiliza apenas a biblioteca padrão do Python
```

### Executando o interpretador

**Modo interativo (REPL):**
```bash
python3 cri.py
```

**Executando um arquivo:**
```bash
python3 cri.py exemplos/hello_world.cri
```

**Executando testes:**
```bash
python3 test_cri.py
```

## Exemplos

A pasta `exemplos/` contém programas de exemplo em CRi:

- **hello_world.cri**: Demonstração básica de impressão e operações simples
- **calculadora.cri**: Exemplos de todas as operações aritméticas suportadas
- **fibonacci.cri**: Cálculo de termos da sequência de Fibonacci
- **operacoes_avancadas.cri**: Operações com precedência e operadores unários

## Referências

Este projeto foi desenvolvido como trabalho final da disciplina de Compiladores e se baseia nos conceitos fundamentais de:

1. **"Crafting Interpreters" por Robert Nystrom**: Inspiração para a arquitetura do interpretador e técnicas de análise sintática recursiva descendente.

2. **"Compilers: Principles, Techniques, and Tools" (Dragon Book)**: Conceitos teóricos de análise léxica, sintática e precedência de operadores.

3. **Técnicas de Recursive Descent Parsing**: Implementação do parser utilizando análise sintática recursiva descendente para expressar a gramática da linguagem.

### Contribuições Originais

- Design da linguagem CRi com foco em simplicidade e facilidade de uso
- Implementação completa do pipeline de compilação em Python
- Sistema de testes unitários para validação das funcionalidades
- Interface de linha de comando com modo REPL interativo

## Estrutura do Código

O projeto está organizado nos seguintes módulos:

### Análise Léxica
- **cri_lexer.py**: Implementa o `CRiLexer` que converte código fonte em tokens
  - `TokenType`: Enum com todos os tipos de tokens suportados
  - `Token`: Estrutura de dados para representar um token
  - `CRiLexer.tokenize()`: Método principal que realiza a tokenização

### Análise Sintática  
- **cri_parser.py**: Implementa o `CRiParser` que converte tokens em AST
  - Classes de nós AST: `NumberNode`, `BinaryOpNode`, `UnaryOpNode`, `PrintNode`, `ProgramNode`
  - `CRiParser.parse()`: Método principal que constrói a árvore sintática
  - Implementação de precedência de operadores via recursive descent parsing

### Interpretação
- **cri_interpreter.py**: Implementa o `CRiInterpreter` que executa a AST
  - `CRiInterpreter._evaluate()`: Avalia nós da AST recursivamente
  - Implementação das operações aritméticas e comando print

### Interface Principal
- **cri.py**: Interface de linha de comando principal
  - Modo REPL para uso interativo
  - Execução de arquivos de código CRi
  - Tratamento de erros e interface do usuário

### Testes
- **test_cri.py**: Testes unitários para validação
  - Testes do lexer, parser e interpretador
  - Casos de teste para operações e precedência

### Etapas de Compilação

1. **Análise Léxica** (`cri_lexer.py`): Converte o código fonte em tokens
2. **Análise Sintática** (`cri_parser.py`): Converte tokens em árvore sintática abstrata (AST)
3. **Interpretação** (`cri_interpreter.py`): Executa a AST diretamente (interpretação tree-walking)

## Bugs/Limitações/Problemas Conhecidos

### Limitações Atuais

1. **Variáveis**: A linguagem não suporta declaração e uso de variáveis
2. **Estruturas de Controle**: Não há loops (for, while) ou condicionais (if)
3. **Funções**: Não é possível definir ou chamar funções
4. **Tipos de Dados**: Suporta apenas números (inteiros e decimais)
5. **Entrada do Usuário**: Não há comando para ler entrada do usuário

### Problemas Conhecidos

1. **Divisão por Zero**: O interpretador detecta e reporta erro de divisão por zero
2. **Precisão Numérica**: Utiliza ponto flutuante do Python, podendo ter imprecisões em operações com decimais
3. **Tratamento de Erro**: Mensagens de erro poderiam ser mais específicas sobre a localização exata do problema

### Melhorias Futuras

1. **Sistema de Variáveis**: Adicionar suporte a declaração e atribuição de variáveis
2. **Estruturas de Controle**: Implementar if/else e loops
3. **Funções**: Adicionar suporte a definição e chamada de funções
4. **Tipos Adicionais**: Suporte a strings, booleanos e arrays
5. **Melhor Tratamento de Erros**: Mensagens de erro mais descritivas e recuperação de erros
6. **Optimizações**: Implementar otimizações na AST para melhor performance

---

## Trabalho Final

### Escopo e organização

O trabalho é de tema livre dentro do escopo da disciplina de compiladores e
consiste no desenvolvimento de alguma aplicação na área da disciplina (um
interpretador para uma linguagem simples, compilador, analisadores de código,
etc.)

O trabalho pode ser feito em grupos de até 4 pessoas.

### Estrutura

Os trabalhos devem ser entregues na atividade própria no [github-classrrom](...).
Cada repositório deve ter uma estrutura parecida com a delineada abaixo:

* **README:** o arquivo README.md na base do repositório deve descrever os
  detalhes da implementação do código. O README deve ter algumas seções 
  obrigatórias:
  - **Título**: nome do projeto
  - **Integrantes**: lista com os nomes, matrículas e turma de cada integrante.
  - **Introdução**: deve detalhar o que o projeto implementou, quais foram as
    estratégias e algoritmos relevantes. Se o projeto implementa uma linguagem
    não-comum ou um subconjunto de uma linguagem comum, deve conter alguns
    exemplos de comandos nesta linguagem, descrendo a sua sintaxe e semântica,
    quando necessário.
  - **Instalação**: deve detalhar os passos para instalar as dependências e
    rodar o código do projeto. Pode ser algo simples como *"Rode
    `uv run lox hello.lox` para executar o interpretador."*, se a linguagem de
    implementação permitir este tipo de facilidade.

    Você pode usar gerenciadores de pacotes específicos de linguagens populares
    como uv, npm, cargo, etc, containers Docker/Podman, ou `.nix`.
  - **Exemplos**: o projeto deve conter uma pasta "exemplos" com alguns arquivos
    na linguagem de programação implementada. Deve conter exemplos com graus
    variáveis de complexidade. Algo como: hello world, fibonacci, função
    recursiva, alguma estrutura de dados e para finalizar um algoritmo um pouco
    mais elaborado como ordenamento de listas, busca binária, etc.
    
    Note que isto é apenas um guia da ordem de dificuldade dos problemas.
    Algumas linguagens sequer permitem a implementação de alguns dos exemplos
    acima.
  - **Referências**: descreva as referências que você utilizou para a
    implementação da linguagem. Faça uma breve descrição do papel de cada
    referência ou como ela foi usada no projeto. Caso você tenha usado algum 
    código existente como referência, descreva as suas contribuições originais
    para o projeto.
  - **Estrutura do código**: faça uma descrição da estrutura geral do código
    discutindo os módulos, classes, estruturas de dados ou funções principais. 
    Explicite onde as etapas tradicionais de compilação (análise léxica, 
    sintática, semântica, etc) são realizadas, quando relevante.
  - **Bugs/Limitações/problemas conhecidos**: discuta as limitações do seu
    projeto e problemas conhecidos e coisas que poderiam ser feitas para
    melhorá-lo no futuro. Note: considere apenas melhorias incrementais e não
    melhorias grandes como: "reimplementar tudo em Rust".
* **Código:** O codigo fonte deve estar presente no repositório principal junto com
  a declaração das suas dependências. Cada linguagem possui um mecanismo
  específico para isso, mas seria algo como o arquivo pyproject.toml em Python
  ou package.json no caso de Javascript.

### Critérios

Cada trabalho começa com 100% e pode receber penalizações ou bônus de acordo com
os critérios abaixo:

- Ausência do README: -50%
- Instruções de instalação não funcionam: até -20%
- Referências não atribuídas ou falta de referâncias: -10%
- Código confuso ou mal organizado: até -15%
- Falta de clareza em apresentar as técnicas e etapas de compilação: -15%
- Bugs e limitações sérias na implementação: até -25%
- Escopo reduzido, ou implementação insuficiente: até 25%
- Uso de código não atribuído/plágio: até -100%
- Repositório bem estruturado e organizado: até 10%
- Linguagem com conceitos originais/interessantes: até +15%
- Testes unitários: até +15%, dependendo da cobertura

Após aplicar todos os bônus, a nota é truncada no intervalo 0-100%. 
