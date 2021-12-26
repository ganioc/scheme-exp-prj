## Reduction Rules and Imperative Programming
Reasoning about procedures. Rules, in the context of the lambda calculus. 

environment sharing and assignment. Abstract Data Type for streams. 

Reasoning about programs. 
- 如何来确定procedure call的结果呢？必须查看procedure的body, 
- 当procedure的formal parameter在body里发现的话，可以预料到在调用procedure时, 输入的参数会在函数体内出现。
- reasoning about programs. 对程序的推理，论证。推理，每一步，一些子表达式，被一个equivalent subexpression来替代。
- a reference to a defined procedure is replaced by the definition of the procedure; evaluate the operand, 在body里面, 替换arguments occurrences of the corresponding formal parameters;
-  literal representation of a value; numeric literals, 

## Lambda Calculus and Beta-Conversion
With a minimum of distraction, most abstract context possible. lambda expression with a single formal parameter, and procedure calls.

```scheme
((lambda (var) exp) rand)

(lambda (z) ((y w) z))

;; substitution of M for x in E,
;; E[M/x],
;; x[M/x]=M
;; y[M/x]=y, c[M/x]=c, 
;; (F G)[M/x]=(F[M/x] G[M/x]).
;; (lambda (y) E'),
;; 如果y与x相同, no further replacements should be done,
;; lambda create a hole in the scope of the outer x,
;; 

;; beta-redex
;; beta-conversion
((lambda (x) E) M)=E[M/x]
((lambda (x) E) M)

(gensym)
(next-symbol)

;; eta-conversion
;; eta-reduction, 


```

Free variables in rand may be captured by bindings of var in the lambda expression. or by other lambda expressions in exp.

## Reduction Strategies
many ways to reduce the expression.

Can an expression be reduced to more than one constant? Fortunately , no. 

### Church-Rosser theorem,
confluence, diamond property, 

### 4.3.1 Applicative-Order Reduction
P134, 
- a constant
- a variable,
- an abstraction, a lambda expression,

lambda-value calculus,

redex?
(reduce-once-appl)
applicative $\beta$-redex, 

reduce的原则:
- 输入一个parsed lambda calculus expression, reduces the 1st redex it finds,如果找到，就返回整个reduced expression
- 如果expression是一个常量、变量、lambda expression, 此时无法被reduced,
- 如果是一个applicative $\beta$-redex, 开始reduction, 返回result,
- 如果是一个application而不是$\beta$-redex, 则
    - 首先尝试reduce the operator,
    - 然后再尝试reduce the operand,
    - 当我们成功的reduce a subexpression, 子表达式时，必须构造一个新的表达式，里面包含精简后的子表达式

```scheme
(reduce-once-appl exp succeed fail)
;; fail, succeed are called continuations,
;; computation将如何继续，在event of success or failure,
;; 
(define-record lit (datum))
(define-record varref (var))
(define-record app (rator rands))

```
P136, app? 84(define-record app (rator rand)), 140, 

beta-redex?, r-P106, 没有做。补上吧。躲不过去。
beta-reduce, r-P107,


