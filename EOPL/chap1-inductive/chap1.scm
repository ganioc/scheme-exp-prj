(define occurs-free?
  (lambda (var exp)
    (cond
     ((symbol? exp) (eqv? var exp))
     ((eqv? (car exp) 'lambda)
      (and
       (not (eqv? var (car (cadr exp))))
       (occurs-free? var (caddr exp))
       )
      )
     (else
      (or
       (occurs-free? var (car exp))
       (occurs-free? var (cadr exp))))
     )))

(define-syntax mylet
  (syntax-rules ()
    ((_ ((x v) ...) e1 e2 ...)
     ((lambda (x ...) e1 e2 ...) v ...))))

(define-syntax myor
  (syntax-rules ()
    ((_) #f)
    ((_ e) e)
    ((_ e1 e2 e3 ...)
     (mylet ((t e1))
	    (if t t (myor e2 e3 ...))))))

(define-syntax mynil!
  (syntax-rules ()
    ((_ x) (set! x '()))))

(define-syntax mywhen
  (syntax-rules ()
    ((_ pred b1 ...)
     (if pred (begin b1 ...)))))

(define-syntax mywhile
  (syntax-rules ()
    ((_ pred b1 ...)
     (let loop () (when pred b1 ... (loop))))))

(define-syntax myfor
  (syntax-rules ()
    ((_ (i from to) b1 ...)
     (let loop ((i from))
       (when (< i to)
	 b1 ...
	 (loop (1+ i)))))))

(define-syntax myincf
  (syntax-rules ()
    ((_ x) (begin (set! x (+ x 1)) x))
    ((_ x i) (begin (set! x (+ x i)) x))))

;; (define-syntax mycond
;;   (syntax-rules (myelse)
;;     ((_ (myelse el ...))
;;      (begin e1 ...))
;;     ((_ (e1 e2 ...))
;;      (when e1 e2 ...))
;;     ((_ (e1 e2 ...) c1 ...)
;;      (if e1
;; 	 (begin e2 ...)
;; 	 (cond c1 ...)))
;;     )
;;   )

(let ((f (lambda (x) (+ x 1))))
  (let-syntax ((f (syntax-rules ()
		    ((_ x) x)))
	       (g (syntax-rules ()
		    ((_ x) (f x)))))
    (list (f 1) (g 1)))
  )

(call/cc
 (lambda (k)
   (* 5 (k 4))))

(+ 2
   (call/cc
    (lambda (k)
      (* 5 (k 4)))))

(define product
  (lambda (ls)
    (call/cc (lambda (break)
	       (let f ((ls ls ))
		 (cond
		  ((null? ls) 1)
		  ((= (car ls) 0) (break 0))
		  (else
		   (* (car ls) (f (cdr ls))))))))))

(let ((x (call/cc (lambda (k) k))))
  (x (lambda (ignore) "hi")))

(((call/cc (lambda (k) k)) (lambda (x) x))
 "Hey!")

((lambda (x) x) "No")
(((lambda (x) x) (lambda (x) x)) "Yes") 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Tests
(define testMylet
  (lambda ()
    (mylet ((a 1))
	   (display "testMylet")
	   (display " -- passed!")
	   (newline))))
(define testMyor
  (lambda ()
    (display "testMyor passed!")
    (newline)
    (myor #f #f))
  )
(define testMywhen
  (lambda ()
    (mywhen #t
	    (display "mywhen --- it is true")
	    (newline))))
(define testMyfor
  (lambda ()
    (let ((i 0))
      (mywhile (< i 10 )
	       (display i)
	       (display #\Space)
	       (set! i (+ i 1))

	       )
      (newline)
      (display "testMyfor -- passed!")
      (newline)
      )
    ))
(define testMyincf
  (lambda ()
    (let ((i 0) (j 0))
      (myincf i)
      (myincf j 3)
      (display (list 'i '= i))
      (newline)
      (display (list 'j '= j))
      (newline)
      (display "testMyincf -- done!")
      (newline))))

(define runTest
  (lambda ()
    (testMylet)
    (testMyor)
    (testMywhen)
    (testMyfor)
    (testMyincf)
    ))
