;; (duple n x) returns a list containing n copies of x
(define duple
  (lambda  (x n)
    (if (eq? x 0)
	'()
	(cons n (duple (- x 1) n)))
    ))

