;; chap1
;; sqrt newton's method
(define (square x)
  (* x x))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (improve guess x)
  (average guess (/ x guess)))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
		 x)))

(define (sqrt x)
  (sqrt-iter 1.0 x))

(define (factorial n)
  (if (= n 1)
      1
      (* n (factorial (- n 1)))))

;;; Tree Recursion
(define (fib n)
  (cond ((= n 0) 0)
	((= n 1) 1)
	(else (+ (fib (- n 1))
		 (fib (- n 2))))))

(define fib-iter
  (trace-lambda fib-iter (a b count)
		(if (= count 0)
		    b
		    (fib-iter (+ a b) a (- count 1)))))
  
(define (fib-2 n)
  (fib-iter 1 0 n))


;; permutations
(define (flatmap proc seq)
  (accumulate append
	      '()
	      (map proc seq)))

(define permutations
  (lambda (s)
    (if (null? s)
	'()
	(flatmap (lambda (x)
		   (map (lambda (p) (cons x p))
			(permutations (remove x s))))
		 s))))

(define (remove item sequence)
  (filter (lambda (x) (not (= x item)))
	  sequence))


;; About frames
;; Image
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))


;;(define (make-sum a1 a2) (list '+ a1 a2))
(define (=number? exp num)
  (and (number? exp)
       (= exp num)))

(define make-sum
  (lambda (a1 a2)
    (cond ((=number? a1 0) a2)
	  ((=number? a2 0) a1)
	  ((and (number? a1)
		(number? a2))
	   (+ a1 a2))
	  (else (list '+ a1 a2)))))

;;(define (make-product m1 m2) (list '* m1 m2))
(define make-product
  (lambda (m1 m2)
    (cond ((or (=number? m1 0) (=number? m2 0)) 0)
	  ((=number? m1 1) m2)
	  ((=number? m2 1) m1)
	  ((and (number? m1)
		(number? m2))
	   (* m1 m2))
	  (else (list '* m1 m2)))))

(define (sum? x) (and (pair? x) (eq? (car x) '+)))

(define (addend s) (cadr s))
(define (augend s) (caddr s))

(define (product? x) (and (pair? x) (eq? (car x) '*)))

(define (multiplier p) (cadr p))
(define (multiplicand p) (caddr p))

(define (deriv exp var)
  (cond ((number? exp) 0)
	((variable? exp)
	 (if (same-variable? exp var) 1 0))
	((sum? exp)
	 (make-sum (deriv (addend exp) var)
		   (deriv (augend exp) var)))
	((product? exp)
	 (make-sum (make-product (multiplier exp)
				 (deriv (multiplicand exp)
					var))
		   (make-product (deriv (multiplier exp) var)
				 (multiplicand exp))))
	(else
	 (error "unknown expression type -- DERIV" exp))
	))

