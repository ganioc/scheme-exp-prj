(letrec ((f (lambda (x)
	      (cons 'a x)))
	 (g (lambda (x)
	      (cons 'b (f x))))
	 (h (lambda (x)
	      (g (cons 'c x)))))
  (cons 'd (h '())))

(define car&cdr
  (lambda (p k)
    (k (car p) (cdr p))))

(define integer-divide
  (lambda (x y success failure)
    (if (= y 0)
	(failure "divide by zero")
	(let ((q (quotient x y)))
	  (success q (- x (* q y)))))))

(define product
  (lambda (ls k)
    (let ((break k))
      (let f ((ls ls) (k k))
	(cond
	 ((null? ls) (k 1))
	 ((= (car ls) 0) (break 0))
	 (else (f (cdr ls)
		  (lambda (x)
		    (k (* (car ls) x))))))))
    ))

(define calc #f)
(let ()
  (define do-calc
    (lambda (ek exp)
      (cond
       ((number? exp) exp)
       ((and (list? exp) (= (length exp) 3))
	(let ((op (car exp)) (args (cdr exp)))
	  (case op
	    ((add) (apply-op ek + args))
	    ((sub) (apply-op ek - args))
	    ((mul) (apply-op ek * args))
	    ((div) (apply-op ek / args))
	    (else (complain ek "invalid operator" op)))))
       (else
	(complain ek "invalid expression" exp)))))
  (define apply-op
    (lambda (ek op args)
      (op (do-calc ek (car args))
	  (do-calc ek (cadr args)))))
  (define complain
    (lambda (ek msg exp)
      (ek (list msg exp))))
  (set! calc
    (lambda (exp)
      ;; grap an error continuation ek
      (call/cc
       (lambda (ek)
	 (do-calc ek exp)))
      ))
  )

(define flip-flop
  (let ((state #f))
    (lambda ()
      (set! state (not state))
      state)))

(define factorial
  (lambda (n)
    (do ((i n (- i 1)) (a 1 (* a i)))
	((zero? i) a))))

(define fibonacci
  (lambda (n)
    (if (= n 0)
	0
	(do ((i n (- i 1)) (a1 1 (+ a1 a2)) (a2 0 a1))
	    ((= i 1) a1)))))

(define divisors
  (lambda (n)
    (do ((i 2 (+ i 1))
	 (ls '()
	     (if (integer? (/ n i))
		 (cons i ls)
		 ls)))
	((>= i n) ls))))

(define scale-vector!
  (lambda (v k)
    (let ((n (vector-length v)))
      (do ((i 0 (+ i 1)))
	  ((= i n))
	(vector-set! v i (* (vector-ref v i) k))))))

(define make-promise
  (lambda (p)
    (let ((val #f) (set? #f))
      (lambda ()
	(if (not set?)
	    (let ((x (p)))
	      (if (not set?)
		  (begin (set! val x)
			 (set! set? #t)))))
	val))))

(define-syntax mydelay
  (syntax-rules ()
    ((_ exp) (make-promise (lambda ()
			     exp)))))

(define stream-car
  (lambda (s)
    (car (force s))))

(define stream-cdr
  (lambda (s)
    (cdr (force s))))

(define counters
  (let next ((n 1))
    (delay (cons n (next (+ n 1))))))

(define-syntax first
  (syntax-rules ()
    ((_ expr)
     (call-with-values
	 (lambda () expr)
       (lambda (x .y) x)))))

(define myequal?
  (lambda (x y)
    (cond
     ((eqv? x y))
     ((pair? x)
      (and (pair? y)
	   (equal? (car x) (car y))
	   (equal? (cdr x) (cdr y))))
     ((string? x) (and (string? y)
		       (string=? x y)))
     ((vector? x)
      (and (vector? y)
	   (let ((n (vector-length x)))
	     (and (= (vector-length y) n)
		  (let loop ((i 0))
		    (or (= i n)
			(and (equal? (vector-ref x i)
				     (vector-ref y i))
			     (loop (+ i 1))))))
	     )))
     (else #f))))

(define mymemq
  (lambda (x ls)
    (cond
     ((null? ls) #f)
     ((eq? (car ls) x) ls)
     (else (mymemq x (cdr ls))))))

(define myassq
  (lambda (x ls)
    (cond
     ((null? ls) #f)
     ((eq? (caar ls) x) (car ls))
     (else (myassq x (cdr ls))))))

(define-syntax myor
  (lambda (x)
    (syntax-case x ()
      ((_) (syntax #f))
      ((_ e) (syntax e))
      ((_ e1 e2 e3 ...)
       (syntax (let ((t e1))
		 (if t t (myor e2 e3 ...))))))))

;; (define-syntax mycond
;;   (lambda (x)
;;     (syntax-case x ()
;;       ((_ (e0 e1 e2 ...))
;;        (and (identifier? (syntax e0))
;; 	    (free-identifier=? (syntax e0) (syntax else)))
;;        (syntax (begin e1 e2 ...)))
;;       ((_ (e0 e1 e2 ...)) (syntax (if e0
;; 				      (begin e1 e2 ...))))
;;       ((_ (e0 e1 e2 ...) c1 c2 ...)
;;        (syntax (if e0 (begin e1 e2 ...)
;; 		   (mycond c1 c2 ...)))))))

(define-syntax mywith-syntax
  (lambda (x)
    (syntax-case x ()
      ((_ ((p e0) ...) e1 e2 ...)
       (syntax (syntax-case (list e0 ...) ()
		 ((p ...) (begin e1 e2 ...))))))))





