(define list-of-numbers?
  (lambda (lst)
    (if (null? lst)
	#t
	(if (pair? lst)
	    (if (number? (car lst))
		(list-of-numbers? (cdr lst))
		#f)
	    #f))))

(define remove-first
  (lambda (s los)
    (if (null? los)
	'()
	(if (eq? (car los) s)
	    (cdr los)
	    (cons (car los)
		  (remove-first s (cdr los)))))))

