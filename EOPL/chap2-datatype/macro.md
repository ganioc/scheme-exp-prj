# What is Scheme's macro

define-syntax

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

## extend-syntax

Macro for extending the syntax of Scheme.

It is defined in ChezScheme, patter-matching style macro definition.

```scheme
extend-syntax (name key ...) (pattern fender template)
```

Kent Dybvig's implementation of EXTEND_SYNTAX, [link](https://www.cs.cmu.edu/afs/cs/project/ai-repository/ai/lang/scheme/code/syntax/extend/0.html)

> References:

- E. Kohlbecker, "Syntactic Extensions in the Programming Language Lisp", PhD Dissertation, Indiana University, 1986.
- R. Kent Dybvig, "The Scheme Programming Language", Prentice Hall, Englewood Cliffs, NJ, 1987.

## Guile's Macro System

- define-syntax
- let-syntax
- letrec-syntax
- syntax-rules
- define-syntax-rules
- syntax-error

### Lisp-style Macro Definitions

## Continuationss

```
(call-with-current-continuation)
```
