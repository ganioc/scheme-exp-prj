# Interpreters 解释器，翻译员,
P163,
前4章为基础理论, 第5章讲述如何来描述编程语言的语法。
使用interpreters, take the abstract syntax tree of a program, 
perform the indicated computation.

用来specifying the semantics of PL, be the major tool for understanding the semantics
of the programming language features.

## A Simple Interpreter
expressed values, possible values of expressions,
    numbers,
    pairs,
    characters,
    strings,
denoted values, values bound to variables,
    cells containing expressed values,

简化版本只有2种expressed values: integer, procedure,

defined language,
defining language,  Scheme, 

concrete syntax, abstract syntax,

* lit (datum)
* app (rator rands)
* varref (var)

init-env? , P143, 
apply-env? 这个在哪里实现的？ P165, 
apply-proc? 这个呢？P143,
P165, 由于一些定义在后，定义的使用在前，造成理解上的无能。

```scheme
(define eval-exp
    (lambda (exp)
        (variant-case exp
            (lit (datum) datum)
            (varref (var) (apply-env init-env var))
            (app (rator rands)
                (let ((proc (eval-exp rator))
                        (args (eval-exp rands)))
                    (apply-proc proc args)))
            (else (error "Invalid abstract syntax: " exp))))))
(define eval-rands
    (lambda (rands)
        (map eval-exp rands)))

```
ff, finite function ADT,

<procedure> ::= <prim-op>. prim-proc(prim-op)
<prim-op> ::= <addition>    +
            | <subtraction> -
            | <multiplication> *
            | <increment>.     add1
            | <decrement>.      sub1

front end, to test the interpreter;

## 如何使用module , 或者库, lib的形式呢？
chez scheme modules,
library?
import, export?
    如何确定library的path呢？
(library-list)
(library-version)
> (library-directories)                                                                                            
(("/Users/yango3/scheme/lib" . "/Users/yango3/scheme/lib")                                                         
  ("." . "."))   
把库放在lib/下面, 文件内容 

```scheme
(library (worker)                                                                                                  
  (export make-worker)                                                                                             
  (import (chezscheme))                                                                                            
  (define (make-worker n)                                                                                          
    (lambda ()  (set! n (+ n 1))  n) )                                                                             
  ;; end library worer                                                                                             
  ) 

(import (chezscheme)
    (worker))
```
**Akku**, 第三方库管理程序，

或者修改, .bashrc,
export CHEZSCHEMELIBDIRS="/home/username/chez-lib:"
export CHEZSCHEMELIBEXTS=".sc::.so:"

init-env add1
P164,

extend-ff, P92, 94, 
extend-ff*, P94, P95,

原来是因为parse出了问题！不支持多个参数!
    lit, 只支持一个number数值,
    需要有一个数据类型，支持array?
需要一个front end来parse expressions ,调用eval-exp,
appendix G, list structure language,
appendix H, list structure parser,
appendix B, building the actual abstract syntax, 
parse, section 3.4.3, P119, 
    - ribassoc, P51, 95, (ribassoc s los v fail-value)
    - 然而这里的parse,只接受一个输入参数，single augument,
P168,

使用appendix D, E 来做一个character-string-parser,
使用appendix F, 来做一个read-eval-print loop, 

还是不行，如果不添加一个新的数据类型的话，恐怕是此路不通！






















