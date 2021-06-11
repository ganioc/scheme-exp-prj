## How to use mit-scheme

https://katex.org/docs/supported.html

## How to write an interpreter?

Reference Code:

```


```

### 1 Inductive of Set of Data

Definition of Grammar

```
List-of-Int ::= ()
List-of-Int ::= (Int . List-of-Int)

// which is a recursive prove.

```

最基本的集合

```
Nonterminal Symbols, Expression, eExpression

BNF(Backus-Naur Form), <expression>

```

Terminal Symbols,

```
.
}
(

)
```

Productions

```
lefthand side, (non terminal symbol)
righthand side, (terminal and nontermial symbols)
::=, is / can be
```

> $$\tag{1}e \,\in\, \normalsize Expression$$

Kleene star

> $$\tag{2}List\text{--}of\text{--}Int\Coloneqq\lparen\{ Int\}^* \rparen$$ >$$\Coloneqq\{Int\}^{*(;)}$$

Syntactic Derivation

> $List\text{--}of\text{--}Int$

> $\implies(Int \centerdot List\text{--}of\text{--}Int)$

> $\implies(Int \centerdot ())$

> $\implies(14 \centerdot ())$

s-list, s-exp

$$S\text{--}list \Coloneqq (\{S\text{--exp}\}^*)$$
$$S\text{--}exp \Coloneqq Symbol \mid S\text{--}list$$

LcExp (lambda expression)

Context-free syntax

### 2

### 3 LET language

LET a simple language.

需要区分 Expression 和 Value

Syntax:

```
Program ::= Expression

Expression ::= Number

Expression ::= -(Expression, Expression)

Expression ::= zero? (Expression)

Expression ::= if Expression then Expression else Expression

// variable
Expression ::= Identifier

Expression ::= let Identifier = Expression in Expression

```

constructors:

```
const-exp  : Int->Exp
zero?-exp  : Exp->Exp
if-exp     : Exp x Exp x Exp -> Exp
diff-exp   : Exp x Exp -> Exp
var-exp    : Var -> Exp
let-exp    : Var x Exp x Exp -> Exp
```

extractor:

```
expval->num :

```

observers:

```
value-of   : Exp x Exp -> ExpVal
```

specification of values:

```
expressed values

denoted values

ExpVal =  Int + Bool
DenVal = Int + Bool

num-val      : Int->ExpVal
bool-val     : Bool->ExpVal
expval->num  : ExpVal->Int
expval->bool : ExpVal->Bool

<< exp >>
AST for expression exp

```

###

### Current Breakpoint

Page 107
