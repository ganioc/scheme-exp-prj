    After some readings on CSUG v9.0, I pick up the study of EOPL version 1 , again!

statememnt oriented language,

expressions, expression oriented langauge such as Scheme.

- literal constant
- variable reference, bound to the variable, value, it's binding,

Using Scheme as an executable meta-language. (to describe another language)

## 4 major strategies:

1. Use of interpreters to explain the run-time behavior of programs in a given language. formal and executable. denotational semantics.
2. Using Scheme programs to make it clear.
3. Emphasize the systematic derivation of low-level implementations from their high-level abstractions.

- variables represented by $$identifiers$$
- standard bindings, standard procedures,
- name of a variable, value of its binding,

- compile time, detect potential type errors, based only on the text of the program, static type checking, no on run-time values,
- run-time value, dynamic type checking,

```scheme
(char? #\$)
(char=?)
(char<?)
(string-length)
(string-append)
(string->symbol)
(string->number)
(string->list)
(string-ref)
;; symbols are quotes
;; list
(append)
(pair)
(vector)
'#(1 2 3)
(vector?)
(vector-ref v3 0)
(vector-length v3)
(vector->list v3)
(eq?)
(procedure?)
(apply + '(2 3))
(map (lambda) '(1 2))
(andmap (lambda) '(1 2 3 4))

```


