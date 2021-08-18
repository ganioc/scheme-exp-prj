;; (duple n x) returns a list containing n copies of x
(define duple
  (lambda  (x n)
    (if (eq? x 0)
	'()
	(cons n (duple (- x 1) n)))
    ))

(define invert
  (lambda (lst)
    (if (null? lst)
	'()
	(let ([a (car lst)])
	  (cons  (cons (car (cdr a))  (car a) ) 
		(invert (cdr lst)))))))
(define cust-list-index
  (lambda (s los n)
    (if (null? los)
	-1
	(if (eq? s (car los))
	    n
	    (cust-list-index s (cdr los) (+ 1 n)))
	) 
    ))

(define list-index
  (lambda ( s los)
    (cust-list-index s los 0)
    ))
(define cust-list-ref
  (lambda (los index n)
    (if (eq? index n)
	(car los)
	(cust-list-ref (cdr los) index (+ 1 n)))
    ))

(define list-ref
  (lambda (los index)
    (cust-list-ref los index 0)
    ))
