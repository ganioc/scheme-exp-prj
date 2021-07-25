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

syntax expander,

**Local Syntax**

```scheme
(let-syntax)
(letrec-syntax)
(fluid-let-syntax)

(let name ((var val) ...)
  exp1 exp2 ...)

((letrec ((name (lambda (var ...) exp1 exp2 ... )))
  name)
  val ...)

(letrec ((name (lambda (var ...) exp1 exp2 ...))
  (name val ...))

(define-syntax let*
  (syntax-rules ()
    ((_ () e1 e2 ...) (let () e1 e2 ...))
    ((_ ((i1 v1) (i2 v2) ...) e1 e2 ...)
      (let ((i1 v1))
        (let* ((i2 v2) ...) e1 e2 ...)))))

(let ((f (lambda (x) (+ x 1))))
    (let-syntax ((g (syntax-rules ()
                      ((_ x) (f x)))))
      (let-syntax ((f (syntax-rules ()
                        ((_ x) x))))
        (g 1))))

(let ((f (lambda (x) (+ x 1))))
    (let-syntax ((g (syntax-rules ()
                      ((_ x) (f x)))))
      (fluid-let-syntax ((f (syntax-rules ()
                              ((_ x) x))))
                        (g 1))))

                        (let ((f (lambda (x) (+ x 1))))
    (let-syntax ((g (syntax-rules ()
                      ((_ x) (f x)))))
      (fluid-let-syntax ((f (syntax-rules ()
                              ((_ x) x))))
                        (g 1))))
```

let is local bindings,

letrec forms a set of variable-value pairs, could be used for mutually recursive procedures.

### Macro

### Continuation

```scheme
(let ((x (call/cc (lambda (k) k)))
    (x (lambda (ignore) "hi")))

(define product
  (lambda (ls)
    (call/cc
     (lambda (break)
       (let f ((ls ls))
         (cond
          ((null? ls) 1)
          ((= (car ls) 0) (break 0))
          (else (* (car ls) (f (cdr ls))))))))))

(let ((x (call/cc (lambda (k) k))))
  (x (lambda (ignore) "hi")))

(define factorial
    (lambda (x)
      (if (= x 0)
          (call/cc (lambda (k) (set! retry k) 1))
          (* x (factorial (- x 1))))))


```

Take the value , bind it to x, and apply the value of x to the value of (lambda (ignore) "hi")

x is bound to the continuaiton itself. this continuation is applied to the procedure resulting from the evaluation of (lambda (ignore) "hi")

Continuation may be used to implement various forms of multitasking. The simple "light-weight process" mechanism defined below allows multiple computations to be interleaved.

Since it is nonpreempttive , it requires that each process voluntarily "pause" from time to time in order to allow the others to run.

> 这是一个非常重要的特性！然而轻描淡写地提了一下。

Continuation is what to evaluate and what to do.

call/cc must be passed a procedure $p$ of one argument. call/cc constructs a concrete representation of the current continuation and passes it to p. The continuation itself is represented by a procedure $k$. Each time k is applied to a value, it returns the value to the continuation of the call/cc application. This value becomes , in essence, the value of the application of call/cc.

If $p$ returns without invoking $k$, the value returned by the procedure becomes the value of the application of call/cc.

It's hard to understand the underlying mechanism.

lexical binding

top-level binding

```scheme
;; about binding


```

with-syntax

**Light Weight Process**

```scheme
(define lwp-list '())
;; Add a procedure into the list
(define lwp
  (lambda (thunk)
    (set! lwp-list (append lwp-list (list thunk)))))
;; 取出一个procedure, 执行之
(define start
  (lambda ()
    (let ((p (car lwp-list)))
      (set! lwp-list (cdr lwp-list))
      (p))))
;; 这段代码是运行的精髓之处！实际上是在队列里添加一个procedure, 然后开始start(取出一个procedure, 执行之)
(define pause
  (lambda ()
    (call/cc (lambda (k)
               (lwp (lambda () (k #f)))
               (start)))))
;; 执行语句, 这个语句实际上是无限循环执行；如果没有pause的话确实是无限循环执行。但是pause是怎么样工作的呢？
(lwp (lambda () (let f () (pause) (display "e") (f))))

;; lwp 即 ligth-weight process, lwp-list 是进程表，不难看出 lwp 和 start 的作用分别是添加一进程到进程表、和从进程表里取出一个进程并执行，理解这段程序的关键在于 pause。

;; pause 是这些进程真正的调度者，它不仅有副作用，而且也不具有引用透明性，所以难以理解，我们分析一下。(lwp (lambda () (k #f))) 把 pause 的 continuation 添加到进程表尾，以备将来恢复。但注意，call/cc 能取出一个函数的全部未来，当然也包括这个函数执行完毕后的后续操作——每一个 lwp 调用 pause 之后的操作是“输出一个字符，然后再递归调用自己”，这些操作当然也在 pause 的 continuation 里面——

(define search-element
  (lambda (element lst)
    (display (call/cc
              (lambda (break)
                (for-each (lambda (item)
                            (if (equal? item element)
                                (break #t)))
                          lst)
                #f)))
                ;;; break to here
    (display "End of\n")))

(define my-for-each
  (lambda (proc items)
    (define iter
      (lambda (things)
        (cond ((null? things))
              (else
               (proc (car things))
               (display "come back\n")
               (iter (cdr things))))))
    (iter items)))

(define generate-one-element-at-a-time
  (lambda (lst)
    ;; continuation procedure
    (define control-state
      (lambda (return)
        (my-for-each
         (lambda (element)
           (call/cc
            (lambda (resume-here)
              (set! control-state resume-here)
              (return element))))
         lst)
        (return 'end)))
    (lambda ()
      (call/cc control-state))))

;; cc作为一个参数的传递, 1st class
(define (mytest element cc)
  (if (zero? element)
      (cc 'found-zero) ;; exit
      (void)
      ))

(define (search-zero test lst)
  (call/cc
   (lambda (return)
     (for-each
      (lambda (element)
        (test element return)
        (printf "~a~%" element))
      lst)
     #f)))

;; 移花接木

(define dish #f)

(define (put! fruit) (set! dish fruit))
(define (get!) (let ([ fruit dish])
                 (set! dish #f)
                 fruit))

(define (consumer do-other-stuff)
  (let loop ()
    (when dish
      (printf "C: get a ~a~%" (get!))
      (set! do-other-stuff
        (call/cc do-other-stuff))
      (loop))
    ))

(define (producer do-other-stuff)
  (for-each
   (lambda (fruit)
     (put! fruit)
     (printf "P: put a ~a~%" fruit)
     (set! do-other-stuff
       (call/cc do-other-stuff)))
   '("apple" "pear" "strawberry" "peach" "grape")))


```

如何解释一下这段代码是怎样工作的呢？Explanations:

- Representing a hole
- 绑定的是函数的接下来的动作，使得函数在上次中断处重新开始
- 另一种函数调用方式，不使用堆栈来保存上下文，而是把这些信息保存在 continuation record 中。continuaiton record 和堆栈的 activation record 的区别在于，它不采用后入先出的线性方式，而是所有的 record 组成一颗树，从一个函数调用另一个函数就相当于给当前节点生成一个子节点，然后把系统寄存器移动到这个子节点。一个函数的退出就相当于从当前节点退回到父节点。这些节点的删除是由 garbage collection 来管理。好处在于，它可以让你从任意一个节点跳到另一个节点，而不必遵循堆栈方式的一层一层的 retrun 方式。

**continuation 的 3 个特性**

- continuation as a first class,可以作为函数的参数被传递和返回
- continuation is represented by procedure,表示将要做的事情
- 假设 call/cc 捕捉了当前的 continuation, 并绑定到 lambda 的参数 cc,那么在 lambda 函数体内，一旦 cc 被直接或间接的作为过程调用，那么 call/cc 会立即返回，并且提供给 cc 的参数即为 call/cc 的返回值 ！

**Other 特性**

- Non-local exit, 非本地退出
- Non Referential Transparent, 非引用透明性,

**Escaping Continuations**

**Tree Matching**

```scheme
(define tree->generator
  (lambda (tree)
    (let ((caller '*))
      (letrec
          ((generate-leaves
            (lambda ()
              (let loop ((tree tree))
                (cond ((null? tree) 'skip)
                      ((pair? tree)
                       (loop (car tree))
                       (loop (cdr tree)))
                      (else
                       (call/cc
                        (lambda (rest-of-tree)
                          (set! generate-leaves
                            (lambda ()
                              (rest-of-tree 'resume)))
                          (caller tree))))))
              (caller '()))))
        (lambda ()
          (call/cc
           (lambda (k)
             (set! caller k)
             (generate-leaves))))))))

(define same-fringe?
  (lambda (tree1 tree2)
    (let ((gen1 (tree->generator tree1))
          (gen2 (tree->generator tree2)))
      (let loop ()
        (let ((leaf1 (gen1))
              (leaf2 (gen2)))
          (if (eqv? leaf1 leaf2)
              (if (null? leaf1) #t (loop))
              #f))))))

```

如何来理解这段程式呢？

- When a generator created by tree‑>generator is called, it will store the continuation of its call in _caller_, so that it can know who to send the leaf to when it finds it.
- then calls an internal procedure called generate‑leaves which runs a loop traversing the tree from left to right. When the loop encounters a leaf, it will use caller to return the leaf as the generator’s result
- but it will remember to store the rest of the loop (captured as a call/cc continuation) in the generate‑leaves variable.
- the last thing generate‑leaves does, after the loop is done, is to return the empty list to the caller.
- 将结果用 caller 返回, 用 generate-leaves 来记录 procedure 运行的位置
- 每一次运行时，resumes its computation,
- 如果进行一般化整理，做进一步的推导。可以互相之间调用，sending results back and forth amongst themselves. coroutines

**Coroutines**

```
;; multi-tasking example, wikipedia上面讲得比较清楚



```

call/cc is used as a control flow operator. Resprents the future.

**CPS**
Continuation Passing Style. Can pass any number of arguments. Success, Failure continuations.

Any program uses call/cc can be rewritten in CPS without call/cc??

**do**

**map**

**apply**

**dynamic-wind**

**eval**

```scheme

(eval '(let ((x 3)) (cons x 4)) (scheme-report-environment 5))
(scheme-report-environment 5)
#<environment *r5rs*>
(interaction-environment)
#<environment *top*>
```

**数据类型**

- constant
  - number
    - integer
    - rational number
    - real number
    - complex number
  - boolean
  - character
  - string

**IO**

current-input-port
current-output-port
open-input-file
close-input-port

---

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
