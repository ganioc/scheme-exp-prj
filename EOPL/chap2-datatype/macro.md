# What is Scheme's macro

- define-syntax

```scheme
(define-syntax when
)

```

syntax-rules

syntax-case

> 可以用来重新定义 syntax-rules

context information is conserved.

syntax

```scheme
(newline)
(display "---")

```

You can effectively reprogram the compiler to change the language and its implementation.

Building your own extended version of Scheme to solve particular kinds of problems. Automating tedious and repetitive aspects of program construction.

## chez-scheme's Macro System

- extend-syntax

Macro for extending the syntax of Scheme. It is defined in ChezScheme, patter-matching style macro definition. Based on pattern matching. extend-syntax is similar to define-syntax, syntax-case, but not automatically respect lexical scoping. Better not to use these 2 at the same time.

```scheme
extend-syntax (name key ...) (pattern fender template)

```

    * name
    * key , else
    * fender, additional constraints on the input expressions,
    * template, form the output,

Attempt to match the input expression against the pattern, in the order the clauses are given. If there is a match, the pattern variable are bound to the corresponding pieces of the input expressions and the fender for the clause. If the fender returns a ture, the given expansion is performed. If no clause is chose, an exception is raised, &assertion.

Kent Dybvig's implementation of EXTEND_SYNTAX, [link](https://www.cs.cmu.edu/afs/cs/project/ai-repository/ai/lang/scheme/code/syntax/extend/0.html)

> References:

- E. Kohlbecker, "Syntactic Extensions in the Programming Language Lisp", PhD Dissertation, Indiana University, 1986.
- R. Kent Dybvig, "The Scheme Programming Language", Prentice Hall, Englewood Cliffs, NJ, 1987.

Syntactic transformations written using extend-syntax are similar to those written using a define-syntax with syntax-case, except that the transformations produced by extend-syntax do not automatically respect lexical scoping.

### example 1

```scheme

(extend-syntax (rec)
    ((rec id val) (let ((id #f))
                    (set! id val) id)))

(extend-syntax (mylet)
               ((mylet ([x e] ...) b1 b2 ...)
                ((lambda (x ...) b1 b2 ...) e ...)))

(mylet ([a 1] [b 2]) (display a) (display b))

(gensym)

```

**denotational semantics**
programming language semantics

macro expansion

## Guile's Macro System

- define-syntax
- let-syntax
- letrec-syntax
- syntax-rules
- define-syntax-rules
- syntax-error

### Lisp-style Macro Definitions

- defmacro
- define-syntax-parameter
- syntax-parameterize

### with

What's the meaning of with?

## Continuationss

```
(call-with-current-continuation)
```
