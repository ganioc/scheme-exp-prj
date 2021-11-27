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
包含两个或更多的alternative类型的类型，叫做union类型，联合类型

所有的alternatives是records, 这样的union类型叫做variant record类型。可变记录, variant record类型。

variant-case

field-list

record-expression,

#### No variant-case
没有发现chez scheme的variant-case
Parser, concrete syntax, abstract syntax,

AST, abstract syntax tree, lambda formal, body,
rator, rand

Erik Hilsdale, 

variant-case, to unparse expressions. 

### 华盛顿大学, rhyspj, spring10cs145/ 课程
CS 145-10, Programming Languages,
- https://www2.seas.gwu.edu/~rhyspj/cs3221/cs3221.html
- SICP
- How to Design Programs
- The Implementation of Functional Programming Languages (Simon Peyton Jones)
- partial evaluation book,

CS 133-10, Algorithms and Data Structures, 
- Duane Bailey's Java Structures

P105

# Appendix A Record Implementation
抄一个define-record, 和variant-case到这里。
需要把这几个函数给搞清楚才能够往下走
尽在appendix.scm这个文件里面,

P486,

To support records, 使用了some syntactic extension, macro facility, 并且using extend-syntax. See Dybvig Kent 1987, for details of this ##extend-syntax## mechanism.

```
// record-proc-name ( name fields)
// name to string,
// 得到一个 symbol, make-name, name?, 每一个field都会生成name->field

// record-indicate (vec-len)
// 得到 (1 2 3 4 ... )直到len-1

// make-unique-name (names)
// 将names list里的所有symbol转换为string, 然后拼在一起，再转换成symbol

```
## extend-syntax
什么是extend-syntax, variant-case呢？


## extensions to syntax-case syntactic

### fluid-let-syntax


### syntax-rules
















