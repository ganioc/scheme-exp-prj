(define (make-rat n d)
  (let ((g (gcd n d)))
    (cons (/ n g) (/ d g))))
  
(define (numer x) (car x))

(define (denom x) (cdr x))

(define (print-rat x)
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))

(define one-half
  (make-rat 1 2))

(define one-third
  (make-rat 1 3))

(define (add-rat x y)
  (make-rat (+ (* (numer x) (denom y))
	       (* (numer y) (denom x)))
	    (* (denom x)
	       (denom y))))

(define (sub-rat x y)
  (make-rat (- (* (numer x) (denom y))
	       (* (numer y) (denom x)))
	    (* (denom x)
	       (denom y))))

(define (mul-rat x y)
  (make-rat (* (numer x) (numer y))
	    (* (denom x) (denom y))))

(define (div-rat x y)
  (make-rat (* (numer x) (denom y))
	    (* (denom x) (numer y))))

(define (equal-rat? x y)
  (= (* (numer x) (denom y))
     (* (numer y) (denom x))))

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))
      ))

(define zero (lambda (f)
	       (lambda (x) x)))

(define (add-1 n)
  (lambda (f)
    (lambda (x)
      (f ((n f) x)))))

(define enumerate-interval
  (trace-lambda
   enumerate-interval (low high)
   (if (> low high)
       '()
       (cons low
	     (enumerate-interval (+ low 1) high)))
		))

(define enumerate-tree
  (trace-lambda
   enumerate-tree (tree)
   (cond ((null? tree) '())
	 ((not (pair? tree)) (list tree))
	 (else
	  (append (enumerate-tree (car tree))
		  (enumerate-tree (cdr tree))))
	 )
   ))

(define accumulate
  (trace-lambda accumulate (op initial sequence)
    (if (null? sequence)
	initial
	(op (car sequence)
	    (accumulate op initial (cdr sequence))))))
(define fold-right accumulate)
(define fold-left
  (lambda (op initial sequence)
    (define iter
      (lambda (result rest)
	(if (null? rest)
	    result
	    (iter (op result (car rest))
		  (cdr rest))))
      )
    (iter initial sequence)))

(define horner-eval
  (trace-lambda horner-eval (x coefficient-sequence)
    (accumulate
     (lambda (this-coeff higher-terms)
       (+ this-coeff (* higher-terms x)))
     0
     coefficient-sequence)))

(define reverse-2
  (trace-lambda
   reverse-2 (sequence)
   (fold-right
    (lambda (x y)
      (append y  (list x) ))
    '()
    sequence
    )))

;; permutations
(define (flatmap proc seq)
  (accumulate append
	      '()
	      (map proc seq)))

(define permutations
  (lambda (s)
    (if (null? s)
	(list '())
	(flatmap (lambda (x)
		   (map (lambda (p) (cons x p))
			(permutations (remove x s))))
		 s))))

(define (remove item sequence)
  (filter (lambda (x) (not (= x item)))
	  sequence))
