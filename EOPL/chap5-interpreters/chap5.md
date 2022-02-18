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

#!/usr/bin/scheme --script
--script, REPL, 
--program, means file content interpreted as an rnrs top-level program,

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

使用appendix D, E 来做一个character-string-parser, 字符解析器,
使用appendix F, 来做一个read-eval-print loop, 

还是不行，如果不添加一个新的数据类型的话，恐怕是此路不通！似乎可以了，看起来
如果直接回到数据的定义的话，就可以把问题的难度极度降低。

## See section 3.4.3, 
这里其实也写到了多个operands的知识。

当可以使用Kleene start or plus, in concrete syntax.
a最方便的处理方法是使用a list of associated subtrees when construcitn an abstract
syntax tree. 

```
<exp> ::= <number> ;; lit (datum)
        | <varref>. ;; varref (var)
        | (if <exp> <exp> <exp>). ;; if (test-exp then-exp else-exp)
        | (lambda ({<var>}*)<exp>) ;; lambda (formals body)
        | (<exp> {<exp>}*  ). ;; app (rator rands)
```

主要的修改在于两点:
    * lambda 接收多个参数, 最后一个是expression , 取最后一个为exp, 前面的都为args,对每一个arg parse,
    * app中的rands也可以接受多个操作数, 取第一个为operator, 其它的都为operands,对每一个operand parse,
    * 增加了一个if语句

```scheme
(cdr '(lambda (x y) (go go))) 
((x y) (go go))

(cdr '(operator arg1 arg2 arg3)) 
(arg1 arg2 arg3) 
```
h回顾一下就可以了。

重新回到5.1.1的学习之中去。！！
  抄写一下 character-string-parser,

#### 那么如何可以include另一个文件呢？
比较方便的方式。
采用library的方法的话，会碰到如下的问题:
Exception: attempt to reference out-of-phase identifier record-proc-names
A: 发现只要将引用的procedure放在另一文件里，import进来就可以识别出来了！


module似乎是在同一个文件里面。在不同的文件里共用代码的话，library看起来最佳。

(include  "xx.ss")   ;; 这个怎么来用呢？
(module)  ;; 模块
(load )
(import)
*.def 文件, xx.def, define-constant, 

include, load,
    使用source-directories, to search for the requested files,
make util.scm a library, 

## 关于implicit parsing
R6RS, as a set of libraries, 推断什么时候bidnding of  imported library are needed. runtime or compile time, 
libraryis可以export 
variable bindings,  when the code is running,
keyword bindings, when the importing code is compiled,
macro transformers, 也需要在compile time ， reference bindings, 

to declare the phases at which libraries are available,
* 当imported code compiled时， variable bindings 是在import code运行时进行的
* 当import library for expand, keyword, variable bindings evaluated
* meta level of its import, run为meta-level 0, expand为meta-level 1,
* macros 可以expand into transformers, 会出现negative meta levels,
* 确定每个library的keyword, variable bindings, 由implementation来决定，from user
* how the identifier used by the importing code,

### implicit parsing model,
library manager, 处理libraries之间的dependencies,
library expander,  处理单个library的expansion, 
    将一个库转换为一个small core language 的代码，与R5RS兼容
    关于bindings,
    code to evaluate keyword bindigns,
    code to evaluate variable bindings,

如果2个库export相似的identifiers的话，是不可以同时引入的，应该通过第三方的库进行改名;
或者可以有选择地引入, 或决定采用的新命名, import-set, qualifiers,
- (only import-set identifier ...) 
- (except import-set identifier ..) ;; 出了这些名字的
- (rename import-set (old new).. ) ;; 选择并改名
- (prefix import-set prefix) ;; 选择所有，但是加一个前缀

### 对生成的新的关键字怎么办呢？
define 将变量variable和value(location holding values)绑定,
define-syntax将keywords和transformer绑定, 
    transformer, 接受一个single value, a syntax object表示一个macro call,返回一个新的syntax object, 返回一个新的语法对象,
hygine macro, 调用的是被调用处的context, 而不是宏内部的context
syntax-object, bindings as set of scope, scope信息和identifier关联起来, s-exp,
transformers, 
    define-syntax使用所有的 Scheme语句来实现功能，转换功能,
    使用syntax-case来match, destructure the input
    syntax来construct the output,

例子为:
```scheme
(define-syntax when
    (lambda (x)
        (syntax-case x ()
            [(when e0 e1 e2 ...)
             (syntax (if e0 (begin e1 e2 ...)))])))
(define-syntax when
    (lambda (x)
        (syntax-case x ()
            [(_ e0 e1 e2 ...)
             #'(if e0 (begin e1 e2 ...))])))
(define-syntax wehn
    (syntax-rules ()
        [(_ e0 e1 e2 ...)
         (if e0 (begin e1 e2 ...))]))
```
这个transformer, 是entire syntactic form, 包含:
    - identifying keyword, 
    - pattern in when, 
    - syntax-case x () ;; auxiliary keyword , else, 
    - 省略， avoid redundant specification, '_'来代替关键字，‘#’‘代替syntax
    - 还可以使用更简短的syntax-rules ()
    - do not capture references in the input to the transformer,

macro expander, introduced in 1986, Kohlbecker et al.
    hygienic nature, lexically scoped.

syntax->datum
```scheme
(library (compile-time-eval)
    (export cteval)
    (import (r6rs) (r6rs eval))
    (define-syntax cteval
        (lambda (x)
            (syntax-case x ()
                [(_ expression library)
                 (list #'quote
                    (eval (syntax->datum #'expression)
                        (environment
                            (syntax->datum #'library))))]))))
```

explicit declaration model, 
The import form of a library defines the language in which the library body is written , regardless of phases.

### Library management
In general , each library is expanded before imported into dependent libraries. import forms of a set of libraries隐含定义了一个依赖图，非回环的。

chain of imports, 
library visitng and invocation, 
    library expander,
    library manager, arrange for keyword and variable definitons evaluated at eh appropriate times,
    估值keyword definition, the visiting a library, 
    估值variable defintion, library intialization expression, invoking a library
A library must be visited when its keyword binding is required,
A library must be invoked when its variabled bindings are requited:
    * expansion of another library or top-level program
    * a run of a top-level program
A library must be expanded exactly once to avoid inconsistencies,

Single expansion,

什么是with-syntax呢？
什么是let-syntax?


A structure is a vector with a unique tag,

### Phased expansion model
How the library body itslf is expanded?
To expand a library L, we assume that all imported libraries have already been expanded to core forms. 

local identifiers,
    - phase of local identifiers, the time value of the binding is computed,
    - phase 0, run phase in Scheme top-level program,
    - right-hand-side expression of a top-level define-syntax form is a phase 1 expression
    - an expression in phase 0 can access any phase 0 identifier that is in the lexical scope of the expression,
    - an expression must be expanded before it is evaluated,
    - transformers , which are evaluated at expression expansion time, cannot access the values of variables that computed at runtime,
    - rejects attempts to residualize a reference to a variable outside of its lexical boundaries, !! 应该就是这个原因
    - 

imported identifiers,
    - 输入的标识符，代表了早已被展开的代码，
    - phase, run, expand, (meta 2), (meta 3), 
    - (for import-set phase ...)

shared vs separate bindings across phases,
    - library的3种状态, uninvoked, invoking, invoked,
    - libraries on demand,

### components of expanded library
into a core-library form, 
    - library meta data, 描述library's products and dependencies
        * library name and version, 
        * library identifier, globally identifier to expanded isntance,
        * identifiers of imported libraries, resolved re-exported identifiers,
        * library substitution, to a set of unique labels, 
        * keyword locations, 
        * variable locations, re-exported variables are looked up through the chains of imports,
        * visit requirements, must be invoked before visti-time code id evaluated,
        * invoke requirement, 

    - library visit-time code, evaluate tranformer definitions,
        * obtain a list of transformers, 
        * list is cached and visit code is never evaluated again, only for compile time, 
    - library invoke time code, 
        * evaluated at compile time, invoked at runtime,
### Target language
Core forms,
    to a core Scheme form, 
Expansion algorithm,
    算法使用的是syntax-case expansion algorithm, Waddell's

回到了**string-parser-character**
P169
P493
可是token-seq的定义找不到。
token-seq-head,
token-seq-tail

ftp.cs.indiana.edu:pub/eopl
www.cs.indiana.edu/hyplan/chaynes/eopl.html

<Organization and Theory of Programming Languages>
https://github.com/prathyvsh
https://github.com/kesava/eopl/blob/master/first-edition/string-parser.rkt


Racket: 
```racket
(require "define-record.rkt")
(require "string-parser.rkt")
(require readline/readline)
(require "util.rkt")
```

There is no single book that is really comprehensive, so you will have
to combine reading the sources to the various free implementations
(e.g., Gambit [Feeley] and S48 [Rees]) with bits and pieces of tech
reports and various books.

<anatomy of LISP> allen
<Programming Languages, An Interpreter-Based Approach> Samuel,
    Includes sources to several interpreters for Lisp-like languages, and a pointer to sources via anonymous ftp
<Les Langages Lisp>











