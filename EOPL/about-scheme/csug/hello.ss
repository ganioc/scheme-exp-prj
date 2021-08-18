;;; hello.ss
(define (hello)
  (printf "hello world~n"))

(define-syntax define-constant
  (syntax-rules ()
    [(_ x e)
     (begin
       (define t e)
       (define-syntax x (identifier-syntax t)))]))

(define calc
  (lambda (x)
    (record-case x
		 [(add) (x y) (+ x y)]
		 [(sub) (x y) (- x y)]
		 [(mul) (x y) (* x y)]
		 [(div) (x y) (/ x y)]
		 [else (assertion-violation
			'calc
			"invalid expression ~s" x)])))
(define prod
  ;; compute the product of the element of ls, bugging out
  ;; with no multiplicaitons if a zero element is found
  (lambda (ls)
    (lambda (k)
      (if (null? ls)
	  1
	  (if (= (car ls) 0)
	      (k 0)
	      (* (car ls) ((prod (cdr ls)) k))))))
  )

;; (define eng
;;   (make-engine
;;    (lambda () 3)))

(define fibonacci
  (lambda (n)
    (let fib ([i n])
      (cond
       [(= i 0) 0]
       [(= i 1) 1]
       [else (+ (fib (- i 1))
		(fib (- i 2)))]))))
(define eng
  (make-engine
   (lambda ()
     (fibonacci 10))))

(define mileage
  (lambda (thunk)
    (let loop ([eng (make-engine thunk)] [total-ticks 0])
      (eng 50
	   (lambda (ticks . values)
	     (+ total-ticks (- 50 ticks)))
	   (lambda (new-eng)
	     (loop new-eng
		   (+ total-ticks 50)))))))

(define snapshot
  (lambda (thunk)
    (let again ([eng (make-engine thunk)])
      (cons eng
	    (eng 1 (lambda (t . v) '()) again)))))

(define round-robin
  (lambda (engs)
    (if (null? engs)
	'()
	((car engs)
	 1
	 (lambda (ticks value)
	   (cons value (round-robin (cdr engs))))
	 (lambda (eng)
	   (round-robin
	    (append (cdr engs) (list eng))))))))
(define first-true
  (let ([pick
	 (lambda (ls)
	   (list-ref ls (random (length ls))))])
    (lambda (engs)
      (if (null? engs)
	  #f
	  (let ([eng (pick engs)])
	    (eng 1
		 (lambda (ticks value)
		   (or value
		       (first-true
			(remq eng engs))))
		 (lambda (new-eng)
		   (first-true
		    (cons new-eng
			  (remq eng engs))))))))))

(define-syntax por
  (syntax-rules ()
    [(_ x ...)
     (first-true
      (list (make-engine (lambda () x)) ...))]))

(define engb
  (make-engine
   (lambda ()
     (engine-block)
     "completed")))
