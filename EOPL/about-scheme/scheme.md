# 一级标题

Status:

- [ ] Choose Scheme
- [x] Choose

## 二级标题

> \<Programming in Scheme\> by Michael Eisenberg, Harold Abelson

> \<The Scheme Programming Language> by Kent Dybvig, aka, TSPL,

---

Books

---

_Scheme_

**Language**

~~Unused Text~~

<u>Important Words</u>

    As we know A is larger than B.

## Define Syntax

What is the difference between define-syntax and define-macro?

### Syntactic Extension

Defined in R5RS.

Except for core syntax, there are extension syntax.

define-sytax associates a syntactic transformation procedure, or transformer with a keyword rather than associating a value with a variable.

User defined syntax is a macro!?

> 将某个过程、或者语法转换与一个关键字相联系，而不是和一个变量相联系。？

Macro is a transformed code. Codes are transformed before being evaluated and compiled. And the procedure continues as if the transformed codes are written from the beginning.

Syntax expander, for each top-level form.

syntax-rules just return syntax transformer,

```scheme
(define-syntax mylet
  (syntax-rules ()
    ((_ ((x v) ...) e1 e2 ...)
     ((lambda (x ...) e1 e2 ...) v ...))))

(define-syntax when
  (syntax-rules ()
    ((when condition exp ...)
      (if condition
          (begin exp ...)))))

(define-syntax myunless
  (syntax-rules ()
    ((_ condition exp ...)
     (if (not condition)
         (begin exp ...)))))


(define-syntax myand
  (syntax-rules ()
    ((_) #t)
    ((_ e) e)
    ((_ e1 e2 e3 ...)
     (if e1 (and e2 e3 ...) #f))))

(define-syntax myor
  (syntax-rules ()
    ((_) #f)
    ((_ e) e)
    ((_ e1 e2 e3 ...)
     (let ((t e1))
       (if t t (or e2 e3 ...))))))

(define testMylet
  (lambda ()
    (mylet ((a 1))
      (display "testMylet")
      (newline))))

;; memq object list eq?
;; memv object list, eqv?

;; How to define let*
;; Homemade let*, works right!
(define-syntax mylet*
  (syntax-rules ()
    ((_ ((x1 v1)) e1 e2 ...)
     (let ((x1 v1))
       (begin e1 e2 ...)))
    ((_ ((x1 v1) (x2 v2) ...) e1 e2 ...)
     (let ((x1 v1))
       (mylet* ((x2 v2) ...) e1 e2 ...)))))


```

\_ (underscore) is the name of the macro.

function can not affect the variables outside due to closure. But macro can! Function can not generate keyword such as if.

pattern/template pair,

pattern variables, match ay substructure and are bound to that substructure within the corresponding template. Allows for zero or more expressions matching the ellipsis prototype pat in the input.

exp ... in the template produces zero or more expressions from the ellipsis prototype exp in the output.

**Local Syntax**

```scheme
(let-syntax)
(letrec-syntax)
(fluid-let-syntax)

```

### Macro

### Continuation

```scheme
 (let ((x (call/cc (lambda (k) k)))
    (x (lambda (ignore) "hi")))

```

Take the value , bind it to x, and apply the value of x to the value of (lambda (ignore) "hi")

x is bound to the continuaiton itself. this continuation is applied to the procedure resulting from the evaluation of (lambda (ignore) "hi")

Continuation may be used to implement various forms of multitasking. The simple "light-weight process" mechanism defined below allows multiple computations to be interleaved.

Since it is nonpreempttive , it requires that each process voluntarily "pause" from time to time in order to allow the others to run.

> 这是一个非常重要的特性！然而轻描淡写地提了一下。

$$
\begin{align*}
<exp> \\ [0.7em]
\delta^L &= \nabla_{a^L}C \odot \sigma'(z^L) & (1) \\[0.7em]
\delta^l &= (w^{l+1})^T \delta^{l+1} \odot \sigma'(z^l) & (2) \\[0.7em]
\frac{\partial C }{\partial b_j^l}  &= \delta^l_j & (3) \\[0.7em]
\frac{\partial C }{\partial w_{kj}^l} &= \delta_k^l a_j^{l-1} & (4)
\end{align*}


$$

**Some demo**

$$
\begin{align*}
\color{blue}a &= b + c \\
  &= e + f

\end{align*}
$$

$$
\begin{align*}
T_{3,-1}(x) &= -4+(-4)\cdot(x-(-1))+\frac{1}{2}\cdot(-8)\cdot(x-(-1))^2+\frac{1}{6}\cdot(-24)\cdot(x-(-1))^3 & \\
              &= -4-4\cdot(x+1)-4\cdot(x+1)^2-4\cdot(x+1)^3
\end{align*}
$$

$$
\begin{align*}
T_{3,-1}(x) &= -4+(-4)\cdot(x-(-1))+\frac{1}{2}\cdot(-8)\cdot(x-(-1))^2 \\
            &= -4-4\cdot(x+1)-4\cdot(x+1)^2-4\cdot(x+1)^3
\end{align*}
$$

# EOPL Version 1

So in book v1, extend-syntax is used. In book v3,

### Lambda Expression

---

$$
\begin{align*}
<exp> & \Coloneqq<varref> \\
    & | (lambda (<var>)<exp>) \\
    & | (<exp> <exp>) \\
    <exp> & \Coloneqq <number>
\end{align*}
$$

$$
\begin{align*}
2x+3y &= 100\\
    x-y &= 30
\end{align*}
$$

---

Lambda expression

```scheme
((lambda (var) exp) rand)

```

Replacing reference to var in exp by rand.$exp[rand/var]$ Free variables in rand may be captured by bindings of var in the lambda expression, or in other expressions in exp.

```scheme
(lambda (x)
  (lambda (y) (x y)))
```

### Lambda Calculus and $\beta\text{-}Conversion$

$E[M/x]$
If E is the variable x, then the result is M. $x[M/x]=M$.

$$
\begin{align*}
y[M/x]&=y \\
(F\,G)[M/x]&=(F[M/x]\enspace G[M/x])
\end{align*}
$$

### Reduction Rules and Imperative Programming

If $y\not=x$ and $y$ does not occur free in $M$, then we can perform the substitution on $E'$.

$$
\begin{align*}
(lambda(y) \:E')[M/x] &= (lambda (y) E'[M/x])

\end{align*}
$$

**$\beta\text{-}conversion$:**

$$
((lambda (x) \:E) \:M) = E[M/x]\\
$$

To which the rule may be applied is $\beta\text{-}redex$.

### Reduction Strategies

An expression can not be reduced to more than one constant.

**Chruch-Rosser theorem**

confluence, or diamond property.

**Applicative-order reduction**

An answer is either of:

- constant
- variable
- abstract (lambda expression)

**lambda-value calculus**

$$
((lambda (x) \, E) \, M) = E[M/x]\\
where M is an answer
$$

### Leftmost Reduction

normal order reduction.

extensive analysis (strictness analysis)

### Defining Recursive Procedure in Lambda Calculus

The variable g is a lambda expression

$$
(lambda\,(g)\,exp)\\
\text{g occurs free in exp}
$$

A procuder Y, (Y f) is the desired recrusive procedure. f is the factorial function.

$$
(Y f)=(f (Y f)
$$

Can Y be written as a lambda expression , or must it be added to the lambda calculus as a special feature?

Y can be defined as, and called Y combinator.

```scheme
(lambda(f)
  ((lambda (x) (f (x x)))
  (lambda (x) (f (x x))))

```

**$\eta\text{-}conversion$**

### sequencing and imperative programming

functional programmiing, when procedures are first class.

Non functional, rather for some side effect on the computation. assignment and input/ouput operations. Order of the evaluation is critical.

sequencing mechanisms. ( the oreder in which side effects are performed )

Statement-oriented languages, sequencing is indicated simply the the ordering ot steatments.

Expression-oriented language, sequencing is required only for expressions that result in side effects.

### Interpreters (Chapt 5)

Via interpreters to study the semantics of programming languages. Take the abstract syntax tree of a program and perform the indicated computation.

### A Simple Interpreter

Procedures take the abstract syntax tree of a program and perform the indicated computation.

Before learned procedures took data in the form of variant records and performed some action determined by the type of record.

**expressed values** (possible values of expressions), **denoted values** (values bound to variables, cells containing expressed values)

For simplicity , there are only two types of expressed values:

$$
\begin{align*}
\text{expressed value} &= \text{Number + Procedure} \\
Denoted value &= Number + Procedure
\end{align*}
$$

There are 2 languages:

- defining language, in this case, it is Scheme.
- defined language

### variant-case (Page 165)

what is variant-case, then?

> From reddit [LINK](https://www.reddit.com/r/Racket/comments/imtqt9/need_help_porting_eopl_macros_to_racket/)
> Earlier in the the first edition of the book, the authors define a couple of key macros define-record and variant-case which are used through out the book. I need help porting then to racket.

And it's mentioned [here](https://gist.github.com/kesava/ec1518495387928d35ec9fc5a764ddbf) that the author provide source code for the macros in scheme in the appendix of the book.

#### define-record

#### variant-case

**Note**
I have to understand the difference between extend-syntax and define-syntax. The former is used by TSPL and book v1, and the latter is used in book v2. What a pitty that it's not expressed clearly in the book. You need to read all the backgound info to understand the situation.

## Scheme Implementation To use

- Chez Scheme v9.9.5
  - Which is from cisco, petty chez scheme is free with an interpreter. Good for book studying.
  - NanoPass?
  - REPL
  - 增量编译器
  - 跨过汇编直接生成二进制 Native Code 的
  - 作者, Kent Dybvig,
  - 从 Scheme 源程序一直编译到机器代码，而不依赖任何其他语言的编译器
- Guile
  - Only support define-syntax.
- Racket
  - Haven't touched it yet.
  - Called PLT Scheme
  - MIT Scheme

### foreign function interface (FFI)

**Further Readings**
<< SICP >>

<< Godel, Escher, Bach: an Eternal Golden Braid, Douglas R. Hofstadter>>

<< The Little Lisper>>

<< Scheme and the art of Programming >>

### Appendix A Record Implementation

Here we see the new special forms of define-record and variant-cases

extend-syntax

### Appendix B Abstract Syntax

For chapter 5.

For chapter 6.

For chapter 7.

For chapter 9.

For chapter 12.

### Appendix C Character String Syntax

### Appendix D Character String Parser

For chapter 5.

### Appendix E Character String Scanner

### Appendix G List Structure Syntax

### Appendix H List Structure Parser

# EOPL Version 2

# EOPL Version 3

# TSPL4

The Scheme Programming Language, 4th Edition,

R6RS version, (Revised Report on Scheme)

forms and procedures.

# CSUG v4

For Chez Scheme features and tools that are not part of R6RS,

Chez Scheme Programming Language Version 9

- automatic storage management
- foreign-language interfaces
- source level debugging
- profiling support
- extensive run-time library
- threads, multi core, multi processor systems,

## design consideration

- reliability
- efficiency

### Identifier

| |

#{ }

```
(gensym)
#{g1 igqhdla2tzdekd9179hovi1fr-2}

#nr

#&17 // box containing the integer 17


```

### fxvectors
