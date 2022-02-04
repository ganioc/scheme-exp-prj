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

;; 4.2.1
;; 1.
((lambda (x) (x (y x)))
z)
=> 
(z (z x))
;; 2.
((lambda (x) (x y))
    (lambda (y) (x y)))
=>
((lambda (z) (x z)) y)
=>
(x y)
;; 3.
((lambda (x)
    (lambda (y) ((x y) z)))
    (lambda (a) y))
=>
(lambda (y) (y z))
;; 4.
((lambda (x)
    (lambda (y)
        ((lambda (x) (z x))
         (lambda (y) (z y)))))
    (lambda (y) y))
=>
((lambda (x)
    (lambda (y)
        (z (lambda (t) (z t)))))
    (lambda (y) y))
=>
(z (lambda (t) (z t)))

;; 4.2.2
;; beta-redex?

;; 3.4.3
;; source-directories



```

Church’s Lambda Calculus

beta-redux?
* Identify the unchanging parts;
* make the changing parts parameters;

ETA conversion rule? eta-redux,
* conversion, reduction , 

## chap 6 The Lambda Calculus
### Untyped Lambda Calculus
1. lambda abstraction

```
λΙ0.Ε
Ι0 - binding identifier,
E  - scope of λI0, 
bound, - occurrences of I0 in E with scope
free,  - unbound identifier is free, 

FV(E): 
FV(λI.E)=FV(E) -  {I}
FV(E1 E2) = FV(E1)υ FV(E2)
FV(I)={I}

E is closed if FV(E)=φ
[Ε1/Ι]Ε2 -> substituion of E1 for all free 
occurrences of I in E2

Eε Expression,
I 属于 Identifier,
```

3个规则，rules:
* α-rule: λI.E =>  λJ.[J/I]E, if J不属于FV(E)
    * choice of binding identifier is uniimportant,

* β-rule: (λΙ.E1)E2 => [Ε2/Ι]Ε1
    * binding of an argument to a binding identifier is just substitution
    * 子表达式, (λI.Ε1)Ε2, 子表达式称为β-redex, 
    * [E2/I]E1, 是它的contractum, 
    * contraction, reduction step, 替换contractum for the redex in E,
    * β-normal form, contains no β-redexes,

* η-rule: λΙ.EI => E, if I不属于FV(Ε)
    * all lambda calculus expressions represent functions,

lambda calculus ia a language of purely functions,

我们只使用β-rule来进行计算, 下面举个例子，substitutions, 代替:

```
(λY.(λX.(Y X))Y)(λZ.X)
=> [λZ.X/Y](λX.(Y X))Y
= (λA.[λZ.X/Y][A/X](Y X))([λZ.X/Y]Y)
= (λA.[λZ.X/Y](Y A))(λZ.X)
= (λA.(λΖ.X)A)(λZ.X)
= [λZ.X/A]((λZ.X)A)
= (λZ.X)(λZ.X)
=> [λZ.X/Z]X 
= X
```

2. application(combination)
    * self-application, 

3. identifier(variable)

lambda calculus and type theory. 

Free variables in rand may be captured by bindings of var in the lambda expression. or by other lambda expressions in exp.

Corollary ( Uniqueness of Normal Forms Property)

Theorem( Standardization Property)
    - leftmost-outermost strategy , lazy evaluation strategy,
    - an argument is not reduced until it finally appears as the leftmost-outermost redex in an expression
    - rightmost-innermost redex each time, eager evaluation, 

### call-by-name and call-by-value reduction,
β-val: (λI.E1)E2 => [E2/I]E1, if E2 is a value,

## An Induction Principle
Proofs of properties of programming languages, by structural induction.

utility of induction on rank. 

typed lambda calculus,

完全看不懂 lambda calculus的推导。

## lambda运算的抽象语法,
假设V是一个变量的集合, τ是满足下列条件的最小集合:
1. if x属于V,则 χ属于τ
2. if t1属于τ, τ2属于τ,则 t1t2属于τ
3. if x属于V, t属于τ,则λx.t属于τ
4. τ是least set , τ被称为lambda term,

定义:
* λx.x 为lambda abstraction, t1,t2为application
* λx.t, 函数,function, takes x, computes the result in its body t,

拓扑、抽象代数、lambda calculus, 函数分析,

### 语法定义
BNF Style, lambda term t, t::= x | t1t2 | λx.t ,

### Bound and Free Variables,
λx.t, x是formal parameter, parameter, the abstraction binds x.

bound , free, enclosing lambda abstraction that binds the variable, 

- FV(t), the set of free variables of a term t, 
    - if t=x, then FV(x)={x} or
    - if t=t1 t2, then FV(t1 t2)= FV(t1)并FV(t2), and
    - if t = λx.t, then FV(λx.t)=FV(t)\{x}
- Closed and Open Terms
    - a term t is closed if FV(t)=空,
    - a closed term is also called a combinator,

### alpha conversion and alpha equivalence,
λx.t, 这是一个abstraction, t是body, 如果y不是t中的free variable的话，我们可以用y来代替x,

alpha conversion, alpha equivalent, 

### Beta Reduction
running or evaluating Lambda Calculus expressions,  Beta reduciton enables computing with lambd a calculus.

#### Substitution
在传统的数学里面, 基本运算calculate, or compute, via substitution. f(x)=x+1,

- 经过替代则为[5/x](x + 1), 在式子里替换x,使用5, 
- [t'/x]t, where all the free occurrences x is replace by the term t',
- [y/x](λy.x), y is captured by the substitution, 
- capture-avoiding substitution,
    - [t/x]y= t, if y=x,
            - 如果= y, if y != x,
    - [t/x](t1 t2) = [t/x] t1 [t/x]t2
    - [t'/x](λy.t) = λy.t, if x=y, y is bound,
            - 如= λy.[t'/x]t, if x!=y, and y不属于FV(t')
#### Beta Reduction,
simple syntax, all need to compute is a varialbe, function abstraction, and funciton applocation.
实际的计算也很简单，优雅, 只有一个规则, beta reduction, reduces function application via substitution. 
最终目标是将一个式子简化成a term, 不能继续被简化的式子, a normal form.

- normal form, there is no 't such that t ->β t',
- Reducible Expression and Beta Reduction,
    - (λx.t1)t2, redex, reducible expression, 
    - 如, ->β [t2/x]t1,
- β-equivalence, 2 terms are β-reducible to each other, =β.
    - 

#### Church Booleans,
- true := λx.λy.x
- false := λx.λy.y
- if := λxb.λy1.λy2.xb y1 y2.

我服了，非常巧妙的定义! 

- not := λxb.λy.λz.xb z y.
- not := λx.x false true.
- and := λx1.λx2.x1 x2 false
- or := λx1.λx2.x1 true x1
- pair = λx1.λx2.λy.y x1 x2
- first = λxp.xp(λx.λy.x)
- second = λxp.xp(λx.λy.y)

#### Church Numberals
We can encode a natural number n as a function that takes a function s (successor)
and z zero and applies s to z n times. referred as Church numerals,

- c0 = λs.λz.z
- c1 = λs.λz.s z
- c2 = λs.λz.s (s z)
- isZero := λxn.xn(λx.false) true

### Recursion
duplicate a term to simulate recursion; fix-point combinators, recursive form,

```scheme
ω = λx.x x
ω t = (λx.x x) t ;; copies of a term 
g := λf.λx. ;; if x <= 0 then 1 else x * f(x-1).
;; open recursion ?
g G.

;; Y Combinator
;; ω ω, 
omega = (λx.x x)(λx.x x) ;; reproduce itself,
Y := λf.(λx.f(x x)) (λx.f (x x)),
;; call by name evaluation would do,
;; a lambda term as a fix point operator in call by name setting

;; Z Combinator
Z:= λf.(λx.f(λy.x x y))(λx.f (λy.x x y)).
;; a lambda term as a fix point operator in call by value setting


````
Lambda算子可以提供了一个数学基础，用来表达任何计算函数。
它的表达能力，served as a foundation for much research and development in 
programming languages. ML family, OCaml, Haskell, 

## Reduction Strategies
many ways to reduce the expression.

Can an expression be reduced to more than one constant? Fortunately , no. 

### Church-Rosser theorem,
confluence, or diamond property, 最终化简成一个相同的表达式；lambda 表达式;

### 4.3.1 Applicative-Order Reduction
什么样的reduction strategy最适合，最能描绘Scheme的行为呢?

P134, reductive的结果为:
- a constant,常量
- a variable, 变量
- an abstraction, a lambda expression, 抽象形式, anything but an application, 

对于application-order reduction, β-reduction只能适用于:operator, operand早已是answers,

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
P136, p84, p130, app
()

(define-record lit (datum))
(define-record varref (var))
(define-record app (rator rands))  // 这里定义了 app?

```
**P136**, app? 84(define-record app (rator rand)), 140, 

beta-redex?, r-P106, 没有做。补上吧。躲不过去。
substitute,
    which takes two expressions, e and m, and a variable x, and returns e[m/x].
    Closely follow the inductive definition of substitution.
    reasoning about programs. 程序的推导。在推导过程中，每一步，一个子表达式被替换;
        procedure-application rule, 为了避免variable capture, 替换过程为E[M/x]
        1. 如果E为variable,x, x[M/x]=M
        2. 如果E为其它的变量或常量, y[M/x]=y, c[M/x]=c,
        3. 如果E为application, (F G), 则为(F G)[M/x]=(F[M/x] G[M/x])
        4. 如果E为lambda, abstraction, (lambda (y) E'), 
            - y与x 相同，则无需替换,
            - 如果x not occur free in E',则也无需替换,
            - 如果y≠x, y not occurs free in M, 可以替换 （lambda (y) E'[M/x])
            - 如果y≠x, x occurs free in E', y occurs free in M, rename y (using α-conversion)
                (lambda (z) (E'[z/y])[M/x]
        ((lambda (x) E) M) = E[M/x]



beta-reduce, r-P107,
需要把这两个函数给实现了，太难了。第2版本没有, 第3版本里面也没有。
;; 现在都实现了，这两个函数

formal, 是什么格式？
body, 是make- record格式。
gensym, 的类型是什么呢？ 如何进行转换呢？
    (gensym) , pretty-name, unique-name,
        > (gensym->unique-string sym1) 
        > (symbol->string sym1)

    (gensym->unique-string)
    (gensym-prefix)
    (gensym-counter)

chez-scheme, 如何获得关于函数的帮助呢？


-------------------------

syntactic, 句法的。
semantic 语义的。

我们来定义它的interface(注意是接口,不是实现).

Constructor
var-exp : Var → Lc-exp
lambda-exp : Var × Lc-exp → Lc-exp
app-exp : Lc-exp × Lc-exp → Lc-exp
Predicates
var-exp? : Lc-exp → Bool
lambda-exp? : Lc-exp → Bool
app-exp? : Lc-exp → Bool
Extractors
var-exp->var :Lc-exp → Var
lambda-exp->bound-var :Lc-exp → Var
lambda-exp->body :Lc-exp → Lc-exp
app-exp->rator :Lc-exp → Lc-exp
app-exp->rand :Lc-exp → Lc-exp

* https://www.slideshare.net/yinwang0
* https://www.slideshare.net/yinwang0/reinventing-the-ycombinator
* https://www.slideshare.net/slideshow/embed_code/12319464

## Definition of lambda-calculus
lambda terms, reduction operations, Wikipedia info,

### terms定义
- x , variable, 
- (λx.M) , Abstraction, Function definition, M is a lambda term,
    - variable x becomes bound in the expression,
- (M N), Application, applying a function to an argument, M and N are lambda terms.
- 可以去除括号，如果表达式不会被混淆的话, 

### reduction operations
alpha-conversion, (λx.M[x]) -> (λ.y.M[y])

beta-conversion, ((λx.M) E) -> (M[x:=E]),在abstraction的body中，使用argument expression替换bound variables,

computable functions:
- 简化1, treat functions anonymously, without giving them explicit names,
- 简化2, only use functions of a single input,  currying, 
- left-associative, 
- Free variables,
    - x , x
    - λx.t, t的free variables ,去除χ,
    - ts, union of set of free variables of t and s
- Capture-avoiding substitutions,
    - x[x:=r] = r
    - y[x:=r]= y if x!= y
    - (ts)[x:=r]=(t[x:=r])(s[x:=r])
    - (λx.t)[x:=r] = λx.t;
    - (λy.t)[x:=r] = λy.(t[x:=r]) if x!=y,y is not a free varialbe of r, y is said to be fresh for r.
- beta-reduction,
    - (λx.t)s -> t[x:=s], 

Α是lambda expressions的集合, 
    - 如果x是一个变量, x∈Α
        - variable is bound to its nearest abstraction,
    - 如果x是一个变量, M∈A, 则(λx.M)∈A, abstraction, 函数, extends right 
        - λx.M N -> λx.(M N)
    - 如果M,N∈A,则(M N)∈ A , applicaiton, 应用，函数的调用, left associative, 
        - M N P -> (M N) P

FV(M), lambda expression M, 的所有free variables的集合, 定义为:
    - FV(x)={x}, x is a variable
    - FV(λx.M) = FV(M)\{x}, 去除x,
    - FV(M N) = FV(M) ∪ FV(N)
    - FV(c) = ∅,for any constant c,


lambda表达式的推导,
    α-conversion, α-equivalent, ,
    β-reduction, local reducibility, 
    η-reduciton, extensionality, 

没有free varialbes的lambda表达式称为closed expression.或combinator,

substitution, 替代原则: Free variable substitution,
    x[x:=N] = N,
    y[x:=N] = y, if x != y,
    (M1 M2)[x:=N] = M1[x:=N]M2[x:=N],
    (λx.M)[x:=N] = λx.M
    (λy.M)[x:=N] = λy.(M[x:=N]), if x≠y and y ∉ FV(N), y不在N的bound里面,

Church numeral,
    是一组高阶函数, 

beta normal form,
    no beta reduction is possible, 

### comparative programming languages,
- to build the ability to evaluate and compare programming languages,
- 判断from the user's and implementor's view,
- develop precise mechanisms for specifying the semantics of programming languages,


## From the Lambda Calculus to Redex
Dr. Racket, 定义你自己的编程语言, 

* declarative programming, 声明式编程, what?
* impeartive programming, 命令式编程, how?, 
* functional programming, 函数式编程，




