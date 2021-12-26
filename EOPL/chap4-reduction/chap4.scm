(load "../chap3-expression/appendix.scm")

(define-record lit (datum))
(define-record varref (var))
(define-record lambda (formal body))
(define-record app (rator rand))

(define reasoning
  (trace-lambda
   reasoning
   (x y)
   (+ (* x 3) y)))

;; Exercise 4.2.2



;; Exercise 4.2.3




;; Figure 4.3.2
(define answer?
  (lambda (exp)
    (not (app? exp))))

(define reduce-once-appl
  (lambda (exp succeed fail)
    (variant-case
     exp
     (lit (datum) (fail))
     (varref (var) (fail))
     (lambda (formal body) (fail))
     (app (rator rand)
	  (if (and (beta-redex? exp)
		   (answer? rand))
	      (succeed (beta-reduce exp))
	      (reduce-once-appl
	       rator
	       (lambda (reduced-rator)
		 (succeed (make-app reduced-rator rand)))
	       (lambda ()
		 (reduce-once-appl
		  rand
		  (lambda (reduced-rand)
		    (succeed (make-app rator reduced-ra)))
		  fail))))))))

