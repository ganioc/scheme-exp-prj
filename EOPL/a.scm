(+ 1 1)
(display "Hello World" )

(define subst-in-s-exp
  (lambda (new old sexp)
    (if (symbol? sexp)
	(if (eqv? old sexp) new sexp)
	(subst-n new old sexp))))

(define subst-n
  (lambda (new old slist)
    (if (null? slist)
	'()
	(cons
	 (subst-in-s-exp new old (car slist))
	 (subst-n new old (cdr slist)))))
  )

(define number-elements-from
  (lambda (lst n)
    (if (null? lst)
	'()
	(cons
	 (list n (car lst))
	 (number-elements-from (cdr lst) (+ n 1))))))

;; Exercise 1.15
(define duple-n
  (lambda (n sym )
    (if (zero? n)
	'()
	(cons sym (duple-n (- n 1) sym)))))




