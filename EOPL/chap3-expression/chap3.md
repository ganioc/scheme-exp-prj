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

```scheme
<tree> ::= <number>|(<symbol> <tree> <tree>)
```

### variant record type
a union type all of whose alternatives are records. 



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

宏的强大之处在于模式匹配上，模式匹配从更高的层次描述输入与输出的关系。通过使用模式匹配，一个表达式可以转换成另一个表达式，而不是直接输出。

scheme , CSUG6, 1998, about Compatibility Features,

expansion-passing-style and extend-syntax macros. 新的版本会使用syntax-case facility. 9.5 version still supports extend-syntax, although I can not find esp-expand.

旧的版本的Chez Scheme会提供两个补充的macro systgems, low-level的EPS, expansion-passing-sytle, 以及一个high level的 extend-syntax 系统。syntax-case expander. 必须设置eps-expand to enable support for expansion-passing-style macros.

expression, expander, to perform further expansion. 

extend-syntax是一个强大的简单的语法扩展，基于pattern matching. 与define-syntax/ syntax-case类似，区别子啊雨前者不会自动respect lexcial scoping.

```scheme
(extend-syntax (name key ...) (pat fender template) ...)
;;; name, syntax keyword, 
;;; 当匹配到car is the name , syntactic transformation procedure  is invoked
;;; key, to be recognized within input expressions during expansion (else in cond or case)
;;; pat, pattern
;;; fender, optional fend, additioanl constraints on the input expression, accessed through the pattern variables, in order for the clause to be chosen
;;; template, output, in terms of the pattern ariables, 

(current-expand)
#<procedure sc-expand>
;; sc-expand to expand syntax-case macros, default expander
;; eps-expand to expand eps macro calls one level only
```

EPS expander has been enabled , to the use of textend-syntax using current-expandeps-expand)

#### What is rec in scheme?
It is a special case of letrec for self-recursive objects. Establishing a binding of var within expr to the value of expr. It's useful for creating recursive objects, especially procedures that do not depend on external variables for the recursion. The procedure defined wsith rec, its meaning is independent of the variable to which it si bound.


#### error
(error obj "string")

### with
只在extend-syntax里面有效, with patterns are the same as extend-syntax patterns, with expressions are the same as extend-syntax fenders, and twith tempaltes are the same as extend-syntax templates.

with can be used to introduce new pattern identifiers bound to expressions produced by arbitray Scheme expressions within extend-syntax templates. Temporary identifier or list of temporary identifiers into a template. 防止命名冲突。

bind a list of pattern variables to a list of temporary symbols,  taking advantage of the fact that with allows us to bind patterns to expressions.

sigma, 将x生成temporary 变量list, 赋值给x list,

#### How to get help from the REPL

### Expansion Passing Style

```scheme
(install-expander keyword expander)
;; keyword, be as a symbol
;; expander, be a procedure, 
;; 新程序应该使用syntax-case, 
(define-syntax-expander keyword exp)
;; exp, 必须evaluate to a procedure,
```
### syntax-rules
递归展开，支持展开，而且是递归展开，

```scheme
(define-syntax AND
    (syntax-rules ()
        [(_} #t)]
        [(_ e1) e1]
        [(_ e1 e2 e3 ...)
            (if e1 (AND e2 e3 ...) #f)]))

(keyword subform ...)
;; 将关键字与转换过程，转换器transformer,关联起来就可以创建新的语法扩展，定义语法扩展
;; define-syntax, let-syntax, letrec-syntax, syntax-rules来创建转换器，它
;; 允许进行简单的基于模式的转换
(define-syntax keyword expr) ;; expr是一个转换器
;; 内部定义所建立的绑定，不论是关键字还是变量，它们在被定义的作用域中是处处可以见的。
(let-syntax ([keyword expr]...) form1 form2 ...)
(letrec-syntax ([keyword expr]...) form1 form2 ...)
(syntax-rules (literal ...) clause ...)
;; clause (pattern template)

```
在开始求值时(在编译或解释之前), 语法扩展会被语法展开起expander转换成基本形式。如果展开起遇到了语法扩展，它会调用与之关联的转换器来展开该语法扩展，并重复对转换器返回的对象进行展开。

Scheme的语法扩展的作用对象时表达式树，而不是单纯的字符替换。宏作用对象时语法树，所以它才会那么强大。

语法扩展，　syntax　extension,
语法扩展被用来简化和常规化在变成中重复出现的模式。

### 卫生宏和非卫生宏
卫生宏，引用透明性，定义阶段的符号定义不会在展开阶段出现意外的绑定。只是表达式的直接替换。而卫生宏需要理解定义，语义，理解咩歌符号所处的环境。

## extensions to syntax-case syntactic

### fluid-let-syntax
与let-syntax类似，通过keyword来引入新的bindings, 在展开body时，改变keyword存在的bindings,也就是during the expansion of form1, form2, each keyword 暂时被新的assocaiation between the keyword and the corresponding transformer. 将所有的keyword的引用rsesolve to same lexcial or top level binding. 

```
(fluid-let-syntax ((keyword expr) ...) form1 form2 form3 ...)

```
integrable procedures may be used as first-class values, and recursive procedures do not cuase indefinite recursive expansion. (ChezScheme CSUG 9.5, syntax.html)

Within lambda-expression, name is rebound to a transformer that expands all references into references to xname. This allows the prcedure to be recursive without causing indefinite expansion. Lexical scoping is maintained automatically by the expander.

expand/optimize procedure ? 

### syntax-rules
```scheme
(syntax-rules (literal ...) clause ...)

```
返回一个 transformer； literal be an identififer other than underscore _ or ellipsssis ... ; clause的形式必须为 (pattern template), (pattern fender template),

### syntax-case
```scheme
(syntax->list syntax-object)

(define syntax->list
    (lambda (ls)
        (syntax-case ls ()
            [() '()]
            [(x . r) (cons #'x (syntax-> list #'r))])))

```

提供了一些procedures and syntac forms, 可以用来简化certain syntactic abstractions coding.

输入a list structured form, returns a list of syntax objects, each representing the corresponding subforms of the input form.

什么是syntax objects呢？

### with-syntax
syntax-error,


### define-syntax


## Compile-time Values and Properties
attach informaiton to identifiers inthe same compile time environment, expander uses to record informaitn about variables, keywords, module names .

```scheme
define-syntax
let-syntax
letrec-syntax
fluid-let-syntax

(make-compile-time-value obj)
(compile-time-value-value ctv)
(define-property id key expr)

```

## module
```scheme
(module m (y) (define y 'm-y))

```

## Variant Records, variant-case,
Branching on the type of the record. 










