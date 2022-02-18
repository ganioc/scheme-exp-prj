# How to use mit-scheme

https://katex.org/docs/supported.html

# How to write an interpreter?

Reference Code:

```


```

## Chap 1 Inductive of Set of Data

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

### s-list, s-exp

$$S\text{--}list \Coloneqq (\{S\text{--exp}\}^*)$$
$$S\text{--}exp \Coloneqq Symbol \mid S\text{--}list$$

LcExp (lambda expression)

Context-free syntax

## Chap 2 Data Abstraction

zero=$\lceil0\rceil$, representation of 0

is-zero?$\lceil{n}\rceil$

successor

predecessor

### Representation Strategies for Data Types

variables, represented by strings, by references into a hash table, even by numbers;

### Environment Interface

environment is a function whose domain is a finite set of variables, range is the set of Scheme values.

{(var1, val1), (var2, val2), ... (varn, valn)}

### define-datatype

How to use defmacro to implement define-datatype?
It's mentioned on the web that define-datatype annd cases are both macros. A macro driven implementation of algebraic data types.

https://eli.thegreenplace.net/archives/all

How to write define-datatype?

Famous Authors:

- Erik Hilsdale
- D. Friedman
- Mitchell Wand
- Kent Dybvig (Chez Scheme)

### cases

How to write cases?

## chap 3 LET language

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

##

## Current Breakpoint

Page 107

# Appeendix
About further readings.

Books change the way you look at the world.

<< Programming Languages: Application and Interpretation >>
    by Shriram Krishnamurthi, Shriram Krishnamurthi

- 1st Structure and Interpretation of Computer Programs, by Hal Abelson
and Gerry Sussman With Julie Sussman, 1985,
- 2nd, Godel, Escher, Bach: an Eternal Golden Braid, Douglas R. Hofstadter, 1979,
- chap 1-4, recursive programming and sybolic computation,
    - The little Lisper by Friedman and Felleisen, 1989,
    - Scheme and the Art of Programming, 1989, Springer and Friedman,
        * less ambitious than SICP,
    - discrete mathematics, for computer science,
- chap 5-7, meta-circular interpreter,
    - denotational semantics, 
    - object-oriented language,
    - CLOS, Common Lisp object -oriented,
- chap 8-10, CPS, continuation-passing style, 
读了一半，没有下文了。

## Appendix B Abstract Syntax
a list structure language,
a character string language,
-> to an identical parse tree, using the record declarations ,

最后生成同样的AST, 


### 如何使用chez Scheme?
 --program
 --script, shell script, 
    - #! /usr/bin/scheme --script
    - #! /usr/bin/scheme-script
-q , --quiet,
Ctrl-D, 退出


echo '(compile-file "filename")' | scheme
compiling test_only.scm with output to test_only.so. ;; object file, 
petite app.so

如何运行一个脚本程序呢？
% chez --program test_only.so
% chez --program test_apdx.scm  ;; 这样也可以执行的, 

expression editor, 必须定义了 TERM environment variable,

revised report,  libraries and top-level programs,
rnrs, 

#### 重新定义appendix,
(meta define)

(library)
(module m (y)
    (define y '123))





