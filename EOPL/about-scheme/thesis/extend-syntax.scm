; The general syntax is
;
; (extend-syntax (name key ...)
;   (pattern [fender] expansion)
;   ...)
;
; where each fender can be omitted and usually is.
; The name is the name of the macro being defined.
; The keys are symbols that are specially recognized by the macro,
; like the else in a cond expression.
; Each pattern is a pattern for the input.
; Each expansion shows what the expanded form of the macro should
; look like if its pattern matches.
; If a fender is specified, it is an arbitrary Scheme expression
; that is evaluated when the pattern matches.  If it returns false,
; then the pattern is treated as though it didn't really match.

; Here's how the let macro could have been defined:

(extend-syntax (lett)
  ((lett ((x e) ...) body ...)
   ((lambda (x ...) body ...)
    e ...)))

(lett ((x 3) (y 4))
  (+ x y))

; Here's a definition of progn as in Common Lisp (it's like begin):

(extend-syntax (progn)
  ((progn) #f)
  ((progn e) e)
  ((progn e1 e2 ...)
   (begin e1 (progn e2 ...))))

(progn)
(progn 3)
(progn (write 1) (write 2) (write 3) 'go)

; Here's an overly complicated definition of cond:

(extend-syntax (condd else)
  ((condd) #f)
  ((condd (else e1 e2 ...))
   (begin e1 e2 ...))
  ((condd (e)) e)
  ((condd (e) clause ...)
   (or e (condd clause ...)))
  ((condd (e e1 ...) clause ...)
   (if e
       (begin e1 ...)
       (condd clause ...))))

(condd)

(condd (else 14))

(condd (34))

(condd (34) (else 19))

(condd
  ((zero? 10) 20)
  ((positive? 10) 30)
  (else 40))

; extend-syntax has several features that aren't illustrated here.
; Get Kent Dybvig's book if you're interested.