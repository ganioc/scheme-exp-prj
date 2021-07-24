(call/cc
 (lambda (k)
   (* 5 4)))

(call/cc
 (lambda (k)
   (* 5 (k 50))))

(+ 2
   (call/cc
    (lambda (k)
      (* 5 (k 2)))))

(define product
  (lambda (ls)
    (call/cc
     (lambda (break)
       (let f ((ls ls))
	 (cond
	  ((null? ls) 1)
	  ((= (car ls) 0) (break 0))
	  (else (* (car ls) (f (cdr ls))))))))))

(let ((x (call/cc (lambda (k) k))))
  (x (lambda (ignore) "hi")))

(((call/cc (lambda (k) k)) (lambda (x) x)) "Hey!")

(display 'World)
(newline)

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
    (call/cc (lambda (k)
	       (lwp (lambda () (k #f)))
	       (start)))))

(define search-element
  (lambda (element lst)
    (display (call/cc
	      (lambda (break)
		(for-each (lambda (item)
			    (if (equal? item element)
				(break #t)))
			  lst)
		#f)))
		;;; break to here
    (display "End of\n")))

(define my-for-each
  (lambda (proc items)
    (define iter
      (lambda (things)
	(cond ((null? things))
	      (else
	       (proc (car things))
	       (display "come back\n")
	       (iter (cdr things))))))
    (iter items)))

(define generate-one-element-at-a-time
  (lambda (lst)
    ;; continuation procedure
    (define control-state
      (lambda (return)
	(my-for-each
	 (lambda (element)
	   (call/cc
	    (lambda (resume-here)
	      (set! control-state resume-here)
	      (return element))))
	 lst)
	(return 'end)))
    (lambda ()
      (call/cc control-state))))

(define (mytest element cc)
  (if (zero? element)
      (cc 'found-zero) ;; exit
      (void)
      ))

(define (search-zero test lst)
  (call/cc
   (lambda (return)
     (for-each
      (lambda (element)
	(test element return)
	(printf "~a~%" element))
      lst)
     #f))
  )

    


