;; Continuation

(define retry #f)

(define factorial
  (lambda (x)
    (if (= x 0)
	(call/cc (lambda (k) (set! retry k) 1))
	(* x (factorial (- x 1))))))

(((call/cc
   (lambda (k) k))
     (lambda (x) x))
 "Hey!")

(define lwp-list '())
(define lwp
  (lambda (thunk)
    (set! lwp-list (append lwp-list (list thunk)))))

(define start
  (lambda ()
    (let ((p (car lwp-list)))
      (set! lwp-list (cdr lwp-list))
      (p))))

(define pause
  (lambda ()
    (call/cc
     (lambda (k)
       (lwp (lambda () (k #f)))
       (start)))))

(define integer-divide
  (lambda (x y success failure)
    (if (= y 0)
	(failure "divide by zero")
	(let ((q (quotient x y)))
	  (success q (- x (* q y)))))))

(define product
  (lambda (ls k))
  (let ((break k))
    (let f ((ls ls) (k k))
      (cond
       ((null? ls) (k l))
       ((= (car ls) 0) (break 0))
       (else
	(f (cdr ls)
	   (lambda (x)
	     (k (* (car ls) x)))))))))



