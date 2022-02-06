;; load variat-case
;;
;; (load "../chap3-expression/appendix.scm")

;; load parse,
;; (source-directories '("." "../chap3-expression"))
(load "../chap3-expression/chap3.scm")

(define-record lit (datum))
(define-record varref (var))
(define-record lambda (formal body))
(define-record app (rator rand))

(define reasoning
  (trace-lambda
   reasoning
   (x y)
   (+ (* x 3) y)))
;; Exercise 4.2.1
;; 1. ((lambda (x) (x (y x)))


;; Exercise 4.2.2
;; parse, in the form of lambda, without arguments
;; then it's lambda 
(parse '(lambda (x) (y z)))
(define beta-redex?
  (trace-lambda
   beta-redex?
   (exp)
   (variant-case
    exp
    (lambda (formal body) #f)
    (app (rator rand) #t)
    (else
     (error "unknown expr" exp)))
   ))
;; (beta-redex? (parse '(lambda (x) (y z)))) 
;; #f
;; > (beta-redex? (parse '((lambda (x) (y x)) z)))
;; #t
;; > (beta-redex? (parse '(lambda (x) ((lambda (x) (y x)) z))))
;; #f

;; Exercise 4.2.3
;; expression: e, m,
;; variable: x,
;; return e[m/x]
(define substitute
  (trace-lambda
   substitute
   (e m x)
   (variant-case
    e
    (lit (datum)
	 (if (eq? datum x)
	     m
	     e))
    (varref (var)
	    (if (eq? var x)
		m
		e))
    (lambda (formal body)
      (cond
       ((eq? formal x) e)
       ((not (free? x body)) e)
       ((and (not (eq? formal x))
	     (not (free? formal m)))
	(make-lambda formal
		     (substitute body
				 m
				 x)))
       ((and (not (eq? formal x))
	     (free? x body)
	     (free? formal m))
	(let ((z (string->symbol
		  (symbol->string (gensym)))))
	  (substitute (make-lambda
		       z
		       (substitute
			   body
			   (parse z)
			   formal))
		      m
		      x)))
       ))
    (app (rator rand)
	 (make-app
	  (substitute rator m x)
	  (substitute rand m x)))
    (else
     (error "unknown expr" e))
    )))
;;> (unparse (substitute (parse '(a b)) (parse 'c) 'b))
;; (a c)
;;> (unparse (substitute (parse '(lambda (a) (a b))) (parse 'a) 'b) 
;; (lambda (g57) (g57 a))


;; Exercise 4.2.4
;; β-reduce, beta-reduce,
(define beta-reduce
  (trace-lambda
   beta-reduce
   (e)
   (if (beta-redex? e)
       (let ((rator (app->rator e))
	     (rand (app->rand e)))
	 (if (lambda? rator)
	     (substitute (lambda->body rator)
			 rand
			 (lambda->formal rator))
	     e)
	 )
       e)))
;; > (unparse (beta-reduce (parse '((lambda (x) (y x)) z))))
;; (y z)
;; (unparse (beta-reduce (parse '((lambda (x) (lambda (y) (x y))) (y w)))))
;; (lambda (g59) ((y w) g59))

;; Exercise 4.2.5
;; eta-redex?,


;; Exercise 4.2.6
;; eta-reduce,


;; 4.2.7
;; eta-expand,





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
		    (succeed (make-app rator reduced-rand)))
		  fail))))))))


;; Exercise 4.3.1
;; reduce-history
(define reduce-history-helper
  (trace-lambda
   reduce-history-helper
   (exp num collect)
   (if (or (not (beta-redex? exp))
	   (<= num 0)
	   )
       collect
       (let ((rator (app->rator exp))
	     (rand (app->rand exp)))
	 (if (app? rand)
	     (let ((new-exp (beta-reduce rand)))
	       (reduce-history-helper
		(make-app rator new-exp)
		(- num 1)
		(append collect
			(list (unparse
			       (make-app rator new-exp))))))
	     (if (not (lambda? rator))
		 collect
		 (let ((new-exp (beta-reduce exp)))
		   (reduce-history-helper
		    new-exp
		    (- num 1)
		    (append collect
			    (list (unparse new-exp)))))
		 )
	     )
	 
	)
       )
   ))
;; > (reduce-history '((lambda (x) (x ((lambda (x) y) z))) w) 5)
;; ((w ((lambda (x) y) z)) (w y))  
;; > (reduce-history '((lambda (x) (x x)) (lambda (x) ( x x))) 3)
;;(((lambda (x) (x x)) (lambda (x) (x x)))
;; ((lambda (x) (x x)) (lambda (x) (x x)))
;; ((lambda (x) (x x)) (lambda (x) (x x)))) 

;;(let ((new-exp (beta-reduce exp)))
	     ;; (reduce-history-helper
	     ;;  new-exp
	     ;;  (- num 1)
	     ;;  (append collect
	     ;; 	      (list (unparse new-exp) 
	     ;; 		    ))))

(define reduce-history
  (lambda
   (exp num)
   (reduce-history-helper (parse exp) num '())
   ))

