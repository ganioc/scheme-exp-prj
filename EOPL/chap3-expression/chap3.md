syntactic patterns, existing forms,

syntactic abstraction,  syntctic sugar, 

records, data abstraction, abstract data types, representation independence. 

P91

## Local Bindings
在前言里面读到第四章之后，可以分散来学习。
top-levle bindings, local bindings, 

lambda expressions, yield procedurs, create local bindings for parameters. binding的范围北限制在procedure的body里面。

### let
```scheme
((lambda (var1 ... varn) body)
    exp1 ... expn)

```
P97

- local procedure call 比global procedure call更容易查找
- 对procedure的代码改动，仅限于local declaration scope;
- 减少了arguments参数的数量, 
- 减少了全局的影响, local binding

## Logical Connectives
conjunction of expressions, connective ,  and

logical disjunction, connective,  or, 

Exercise 3.3.1

```
if->cond

name-op
judge
true-op
false-op


```
## branching

Exercise 3.3.2

```
case

```
variant-case?

## Records
Implemented with a syntactic extension facility.
See Appendix A for details.

define-record

make-name, takes n arguments, and returns a new record of the given type with field.

name->filedi, for 1<=1 <=n; 

binary trees:

<tree>::= <number> | (<symbol> <tree> <tree>)

interior-symbol  // 这里没有使用->符号

### Variant Records and variant-case








