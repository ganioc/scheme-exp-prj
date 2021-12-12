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




