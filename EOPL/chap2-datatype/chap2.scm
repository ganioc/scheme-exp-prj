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

(define cust-vector-index
  (lambda (s vec index)
    (if (= 0 (vector-length vec))
	'()
	(if (eq? s (vector-ref vec index))
	    index
	    (cust-vector-index s vec (+ 1 index))))
    ))

(define vector-index
  (lambda (s vec)
    (cust-vector-index s vec 0)
    ))

(define ribassoc
  (lambda (s lst vec msg)
    (let* ((index (list-index s lst)))
      (if (= index -1)
	  msg
	  (let ((fb (vector-ref vec index)))
	  (if (null? fb)
	      msg
	      fb)
	  )))))

(define remove-first
  (lambda (s los)
    (if (null? los)
	'()
	(if (eq? (car los) s)
	    (cdr los)
	    (cons (car los) (remove-first s (cdr los)))))))

(define remove
  (lambda (s los)
    (if (null? los)
	'()
	(if (eq? (car los) s)
	    (remove s (cdr los))
	    (cons (car los) (remove s (cdr los)))))))

(define partial-vector-sum
  (lambda (von n)
    (if (zero? n)
	0
	(+ (vector-ref von (- n 1))
	   (partial-vector-sum von (- n 1))))))

(define vecotr-sum
  (lambda (von)
    (partial-vector-sum von (vector-length von))))

;;> (down '(1 2 3))                                                            ;;   ((1) (2) (3))
;;
;;> (down '(a (more (compolicated)) object))                                   ;;   ((a) ((more (compolicated))) (object))
;;
(define down
  (lambda (lst)
    (if (null? lst)
	'()
	(cons (cons (car lst) '())
	      (down (cdr lst))))))


;;  (up '((x (y)) z))
;;  (x (y) z)
(define up
  (trace-lambda up (lst)
		(if (null? lst)
		    '()
		    (if (list? (car lst))
			(append (car lst) (up (cdr lst) ))
			(append (list (car lst)) (up (cdr lst)))
			))))


(define half
  (trace-lambda half (x)
		(cond
		 [(zero? x) 0]
		 [(odd? x) (half (- x 1))]
		 [(even? x) (+ (half (- x 1)) 1)])))


(define count-occurrences
  (trace-lambda count-occurrences (s slst)
		(if (null? slst)
		    0
		    (if (list? (car slst))
			(+ (count-occurrences s (car slst))
			   (count-occurrences s (cdr slst)))
			(if (equal? s (car slst))
			    (+ 1 (count-occurrences s (cdr slst)))
			    (+ 0 (count-occurrences s (cdr slst))))
			))
		))
