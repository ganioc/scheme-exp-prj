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


