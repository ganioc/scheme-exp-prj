(define (op1 arg)
  (display "go op1")
  (newline)
  )
(define calc
  (lambda (num)
    (let ((a 21)
	  (b 10))
      (cond
       ((eq? num 0) (+ a 10)) 
       (else
	(calc (- num 1))
	))
      )
    ))

(define (prepend-every item lst)
  (map (lambda (choice)
	 (se item choice)) lst))
(define (choices menu)
  (if (null? menu)
      '(())
      (let ((smaller (choices (cdr menu))))
	(reduce append
		(map (lambda (item) (prepend-every item smaller))
		     (car menu))))))
