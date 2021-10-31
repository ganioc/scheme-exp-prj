;; chap3
(define subst
  (lambda (new old slst)
    (if (null? slst)
	'()
	(let ((car-value (car slst))
	      (cdr-result (subst new old (cdr slst))))
	  (if (symbol? car-value)
	      (if (eq? car-value old)
		  (cons new cdr-result)
		  (cons car-value cdr-result))
	      (cons (subst new old car-value)
		    cdr-result))))))

;; Exercise 3.1.2
(define let->application-helper
  (trace-lambda let->application-helper (lst)
		(cond
		 [(null? lst) '()]
		 [else
		  (cons (cadar lst)
			(let->application-helper
			 (cdr lst)))])))
(define let->application-collect
  (trace-lambda let->application-collect (lst)
		(cond
		 [(null? lst) '()]
		 [else
		  (cons (caar lst)
			(let->application-collect
			 (cdr lst)))])))

(define let->application
  (trace-lambda let->application (slst)
		(if (eqv? 'let (car slst))
		    (cons
		     (list 'lambda
			   (let->application-collect
			    (cadr slst))
			   (caddr slst))
		     (let->application-helper
			    (cadr slst))
		     )
		    '())
		))
