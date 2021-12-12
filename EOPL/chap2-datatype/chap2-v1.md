## Induction Recursion and Scope
参考代码: github.com/rubenbarroso/EOPL

### Inductive Specification

一种数学推导论证,

Backus-Naur Form and Syntactic Derivations,

BNF用来定义一些sets, which are called syntactic categoreies, nonterminals, <> surrounded.

Kleene star {...}*

## 常用的函数

```
append




```

Use little schemer?
10th amendment?

### arbitray number of arguments
怎么去实现呢？
不加括号，args, 就是输入为一个list
```
(define (procedure . args)
(lambda args ...)
#\newline

```
(printf)

page 55,

## 2.3 Static Properties of Variables
### Free and Bound Variables
lambda calculus,
formal parameter

A variable is to be occur bound: if the expression contains a bound reference to the variable.

occur free: if the expression contains a free reference to the variable.

在运行时，evaluate时，所有的variable references必须associated some values.

lexically bound: bound to a formal parameter

globally bound: bound at top level by definitions or be supplied by the system.

combinator: Lambda expressions without free variables.

Identity function:

formal parameters

operands

扩展if expressions, 来定义occurs-free, occurs-bound

### 2.3.2 Scope and Lexical Address
region: declaration is effective

scope, region

block ,block structured,

inner declaration supersedes the outer one,

scope of a declaration,

to which declaration a reference refers 

borders of regions, contours, a number of contours may crossed before arriving at the associated declaration. lexical (static) depth of the variable references.

lexical address of the variable reference.
(v: d p)

### Exercise 2.3.10
这里的代码非常精巧，对源代码进行了分析和转换。

```scheme
(lexical-address '(lambda (a b c)                                              
                      (if (eqv? b c)                                             
                          ((lambda (c)                                           
                             (cons a c))                                         
                           a)                                                    
                          b)))                                                   
(lambda (a b c)                                                                  
  (if ((eqv? free) (b : 0 1) (c : 0 2))                                          
      ((lambda (c) ((cons free) (a : 1 0) (c : 0 0))) (a : 0 0))                 
      (b : 0 1)))  
```
expression可以是一个symbol, 也可以是一个lambda表达式，或其它表达式。

已经用depth-postion, 替代后，表达式（非formal parameters）中的值的名称就并不重要了。

### 2.3.2 Renaming Variables
a general program transformation rule. 规则，
如果lambda expression的一个formal parameter改变了，所有的引用也改变了, 表达式的功能不变。新命名不能和original lambda expression里的free variable冲突。

exp[y/x], exp with y for x,

alpha-conversion, 这个被称为,

rename. 

There are 2 difficulties:
- 如果在expression里面occurs-free, 则可以更改。
- if an inner formal parameter declaration create a hole in the scope of the outer formal parameter: the references to the inner declaration should not be changed.

Page 89

先完成一个完全拷贝。接下来再加判断，替换。

occurs-free:
- E is a varaible reference and E is the same as x;
- E is of the form (E1 E2) and x occurs free in E1 or E2;
- E is of the form(lambda (y) E'), where y is differnent from x and x occurs free in E'

occurs-bound:
- E is of the form (E1 E2) and x occurs bound in E1 or E2
- E is of the form (lambda (y) E'), where x occurs bound in E' or x and y are the same variable and y occurs free in E'









