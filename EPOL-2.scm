(define add2
  (lambda (n)
    (+ n 2)))

(add2 1)

(define compose
  (lambda (f g)
    (lambda (x)
      (f (g x)))))

(define add4 (compose add2 add2))

;; implementation of cells
(define cell-tag "cell")

(define make-cell
  (lambda (x)
    (vector cell-tag x)))

(define cell?
  (lambda (x)
    (if (vector? x)
	(if (= (vector-length x) 2)
	    (eq? (vector-ref x 0) cell-tag)
	    #f)
	#f)))

(define cell-ref
  (lambda (x)
    (if (cell? x)
	(vector-ref x 1)
	(error "Invalid argument to cell-ref:" x))))

(define h
  (lambda (d)
    (lambda (a)
      (cons a d))))

;; (define curry2
;;   (lambda (f)
;;     (lambda (a)
;;       (lambda (b)
;; 	(f a b)))))

(define curry2
  (lambda (f)
    (lambda (a)
      (lambda (b)
	(f (string-append a b))))))
(((curry2 display) "Fu Hao") "Wu Ding")
;; (((curry2 "Fu") "Wu") 'display)

(define curry-me
  (lambda (f)
    (lambda (s)
      (lambda (t)
	(f s)
	)
      )))
;; (() (curry-me display) "a b c d e f g")
(((curry-me display) "Fu") "t") 
(((curry2 display) "Qian Ji Nian") " -*-")  

(define plus
  (lambda x
    (if (null? (cdr x))
	(lambda (y) (+ (car x) y))
	(apply + x))))

(plus 1 2)

;; Exercises
;; Exercise 1
(define duple
  (lambda (n x)
    (if (<= n 0)
	'()
	(cons x (duple (- n 1) x)))))
(duple 2 3)
(duple 5 2)

;; Exercise 2
(define invert
  (lambda (lst)
    (if (null? lst)
	'()
	(cons (cons (list-ref (car lst) 1) (list-ref (car lst) 0) )
	      (invert (cdr lst))))
    )
  )

(define samplelst '((a 1) (a 2) (b 1) (b 2)))
samplelst
(invert '((a 1) (a 2) (b 1) (b 2)))

(display samplelst)
(display (cdar samplelst))
(display (caar samplelst))
(cons (cdar samplelst) (caar samplelst))
(list (cdar samplelst) (caar samplelst))

(define loopsamplelst
  (lambda (lst)
    (if (null? lst)
	'()
	(begin
	  (display (car lst))
	  (display (list (list-ref (car lst) 1)
			 (list-ref (car lst) 0)))
	  (loopsamplelst (cdr lst))))
    ))

(loopsamplelst samplelst)
    
(define invert-lst
  (lambda (lst)
    (if (null? lst)
	'()
	(begin
	  (append (list (list (list-ref (car lst) 1)
			      (list-ref (car lst) 0)) ) 
		  (invert-lst (cdr lst)))))

    ))
(invert-lst samplelst)

;;; Exercise 3
(define list-index-helper
  (lambda (s lstos ind)
    (if (null? lstos)
	-1
	(if (eq? s (car lstos))
	    ind
	    (list-index-helper s (cdr lstos) (+ 1 ind))))
    ))
(define list-index
  (lambda (s lstos)
    (if (null? lstos)
	-1
	(list-index-helper s lstos 0)
	)))

(list-index 'c '(a b c d))
(list-ref '(a b c) (list-index 'b '(a b c)))


;;;; Exercise 4
(define vector-index-helper
  (lambda (s vos index)
    (if (eq? (vector-length vos) 0)
	-1
	(if (eq? s (vector-ref vos index))
	    index
	    (vector-index-helper s vos (+ 1 index))))
    ))
(define vector-index
  (lambda (s vos)
    (if (eq? (vector-length vos) 0)
	-1
	(vector-index-helper s vos 0)
	)
    ))

(vector-index 'c '#(a b c d))

(vector-ref '#(a b c) (vector-index 'b '#(a b c)))

;;;; Exercise 5
(define ribassoc
  (lambda (s los v fail-value)
    "Nonsense"
    ))

(ribassoc 'a '() 'a '0)

;;;;Exercise 6
;; (define filter-in-helper
;;   (lambda ()))

(define filter-in
  (lambda (predic lst)
    (if (null? lst)
	'()
	(if (predic (car lst))
	    (cons (car lst) (filter-in predic (cdr lst)))
	    (filter-in predic (cdr lst))
	    )
	)
    ) 
  )

(filter-in number? '(a 2 (1 3) b 7))

;; Exercise 7
;; I think it is an excellent solution, using recursion.
(define product
  (lambda (los1 los2)
    (if (or (null? los1) (null? los2)) 
	'()
	(cons (list (car los1) (car los2))
	      (append (product (list (car los1)) (cdr los2))
		    (product (cdr los1)  los2))))
	 
	)
    )

(product '(a b c ) '(x y))


;; Exercise 8
;; Beautiful implementation.
(define swapper
  (lambda (s1 s2 slst)
    (cond ((null? slst) '())
	  ((eq? s1 (car slst)) (begin
				 (cons s2
				       (swapper s1 s2 (cdr slst)))))
	  ((eq? s2 (car slst)) (begin
				 (cons s1
				       (swapper s1 s2 (cdr slst)))))
	  ((pair? (car slst)) (begin
				(cons (swapper s1 s2 (car slst))
				      (swapper s1 s2 (cdr slst)))
				))
	  (else (begin
		  (cons (car slst)
		  (swapper s1 s2 (cdr slst)))
		  )))))

(swapper 'a 'd '(a b c d)) 
(swapper 'x 'y '((x) y (z (x))))

;; Exercise 9
;; For invert sequence
(define rotate
  (lambda (los)
    (cond ((eqv? (length los) 1) (list (car los) ))
	  (else (append (rotate (cdr los)) (list (car los))))
	  )
    ))
(rotate '(a b c d))
(define rotate-last-helper
  (lambda (los pre)
    (cond ((eqv? (length los) 1) (append (list (car los))
					 pre))
	  (else (rotate-last-helper (cdr los)
				    (append pre (list (car los)))))
	  )
    ))
(define rotate-last
  (lambda (los)
    (cond ((null? los) '())
	  (else (rotate-last-helper los '()))
	  )))
(rotate-last '(a b c d))
(rotate-last '(notmuch))
(rotate-last '())

;;; Exercise 2.2.8
;;  These are a bit harder.
;; 1
(define down
  (lambda (lst)
    (cond ((null? lst) '())
	  (else (cons (list (car lst))
		      (down (cdr lst))
		      ))
	  )
    ))
(down '(1 2 3))
(down '(a (more (complicated)) object))

;; 2
;; up
(define up
  (lambda (lst)
    (cond ((null? lst) '())
	  ((list? (car lst)) (append
			      (list (car (car lst)))
			      (cdr (car lst))
			      (up (cdr lst))
			      )) 
	  (else (append (list (car lst))  (up (cdr lst))))
    )))
(up '((1 2) (3 4)))
(up '((x (y)) z))

;; 3
;; count-occurrences
(define count-occurrences
  (lambda (s slst)
    (cond ((null? slst) 0)
	  ((pair? slst)  (+ (count-occurrences s (car slst))
			    (count-occurrences s (cdr slst))
			    ))
	  ((eq? slst s) 1 )
	  (else 0)
	  )
    ))
(count-occurrences  '1 '(1 2))
(count-occurrences 'x '(x y z))
(count-occurrences 'x '((f x) y (((x z) x))))
(count-occurrences 'w '((f x) y (((x z) x))))

;; 4
;; flatten
(define flatten
  (lambda (slst)
    (cond ((null? slst) '() )
	  ((pair? (car slst)) (append '()
				      (flatten (car slst))
				      (flatten (cdr slst))
				      ))
	  (else (append '() (list (car slst))
			(flatten (cdr slst) )))
	  )
    ))
(flatten '(a b c))
(flatten '((a b) c  (((d)) e)))

;; 5
;; merge , ascending order lists
(define merge
  (lambda (lon1 lon2)
    (cond ((null? lon1) lon2)
	  ((null? lon2) lon1)
	  (else (let ((h1 (car lon1))
		      (h2 (car lon2)))
		  (cond ((<= h1 h2) (append '()
					   (list  h1)
					   (merge (cdr lon1) lon2)))
			(else (append '()
				      (list h2)
				      (merge (cdr lon2) lon1)))
			)
		  ))
	  )
    ))
(merge '(1 4) '(1 2 8))
(merge '(35 62 81 90 91) '(3 83 85 90))


;; Exercise 2.2.9
;; These are harder still
;; 1 path
;; (define path-helper
;;   (lambda (value lst pathlst)
;;     (let ((val (list-ref lst 0))
;; 	  (left-lst (list-ref lst 1))
;; 	  (right-lst (list-ref lst 2)))
;;       (if (eq? value val)
;; 	  (pathlst)
;; 	  ;; If left-lst not empty
;; 	  (if (not (null? left-lst))
;; 	      (path-helper value left-lst (append pathlst '(L)))
;; 	      ;; else if right-lst not empty
;; 	      (if (not (null? right-lst))
;; 		  (path-helper value right-lst (append pathlst '(R)))
;; 		  )
;; 	      )
;; 	  )
;;       )
;;     ))
;; (define path
;;   (lambda (value lst)
;;     (if (eq? value (list-ref lst 0))
;; 	'()
;; 	(path-helper value lst  '()))
;;     ))

;; (path 8 '(8 () ()))
(define list2.2.9 '(1 (14 () ())
		      (7 () ()))
  )
(define list2.2.9-2 '(14 (7 () (12 () ()))
			 (26 (20 (17 () ())
				 ())
			     (30 () ()))))
(define mypath-helper
  (lambda (value lst pathlst)
    (let ((val (list-ref lst 0))
	  (left-lst (list-ref lst 1))
	  (right-lst (list-ref lst 2)))
      (display "\nCurrent val:")
      (display val )
      (if (eq? val value)
	  pathlst
	  (if (and (null? left-lst)
	  	   (null? right-lst))
	      '()
	      (if (not (null? left-lst))
	  	  (let ((left-fb (mypath-helper value
	  					left-lst
	  					(append pathlst '(L)))))
	  	    (if (not (null? left-fb)) 
	  		left-fb
	  		(if (not (null? right-lst))
	  		    (let ((right-fb (mypath-helper value
	  						   right-lst
	  						   (append pathlst  '(R)))))
	  		      (if (not (null? right-fb))
	  			  right-fb
	  			  '())
	  		      ))
	  		)
	  	    )
		  ;; left is empty
		  (if (not (null? right-lst))
		      (let ((right-fb (mypath-helper value
						     right-lst
						     (append pathlst '(R)))))
			(if (not (null? right-fb))
			    right-fb
			    '())
			)
		      )
	  	  )
	      )
	  )
      )
    )
  )
(define mypath
  (lambda (value lst)
    (display value)
    (if (eq? value (list-ref lst 0))
	(begin
	  (display "Found at root")
	  (display value)
	  '())
	(mypath-helper value lst '())
	)
    ))

(mypath 14 list2.2.9)

;; Exercise 2.2.9 - 2
;; car&cdr
;; To generate a procedure
(define car&cdr-car
  (lambda (s lst sym-lst)
    ;; (display "\ncar&cdr-car\n")
    ;; (display lst)
    ;; (newline)
    ;; (display sym-lst)
    ;; (newline)
    (if (pair? lst)
	(car&cdr-helper s lst (list 'car sym-lst) )
	(if (eq? lst s)
	    (list 'car sym-lst) 
	    '())
	)
    ))
(define car&cdr-helper
  (lambda (s lst sym-lst)
    (if (null? lst)
	'()
	(let ((result (car&cdr-car s (car lst)
				   sym-lst)))
	  (if (null? result)
	      (car&cdr-helper s (cdr lst)
			   (list 'cdr sym-lst))
	      result
	      )
	  )
	)))
(define car&cdr
  (lambda (s lst errvalue)
    ;; '(lambda (lst) (car lst))
    ;; (debug)
    (let ((result (car&cdr-helper s lst 'lst) )
	  )
      (if (null? result)
	  errvalue
	  (append '(lambda (lst)) (list result) )
	  )
      )))
(car&cdr 'a '(a b c) 'fail)
(car&cdr 'c '(a b c) 'fail)
(car&cdr 'dog '(cat lion (fish dog) pig) 'fail)
(car&cdr 'a '(b c) 'fail)

;; 2.2.9
;; 3 car&cdr2   sym-lst 包含了'compose 
(define car&cdr2-car
  (lambda (s lst sym-lst)
    (if (pair? lst)
	(let ((result (car&cdr2-car s (car lst)
				    (list 'compose 'car  sym-lst))))
	  (if (null? result)
	      (car&cdr2-helper s (cdr lst)
			       (list 'compose 'cdr
				     (list 'compose 'car sym-lst)))
	      result)
	  )
	(if (eq? s lst)
	    (list 'compose 'car  sym-lst) 
	    '())
	)
    ))
(define car&cdr2-helper
  (lambda (s lst sym-lst)
    (if (null? lst)
	'()
	(let ((result (car&cdr2-car s (car lst)
				    sym-lst)))
	  (if (null? result)
	      (car&cdr2-helper s (cdr lst)
			       (if (and (eq? 'compose (car sym-lst))
					(eq? 'cdr (cadr sym-lst)))
				   (append (list 'compose 'cdr)
					   (cdr sym-lst))
				   (list 'compose 'cdr sym-lst)
				   )
			    )
	      result)
	  )	
	)
    ))
(define car&cdr2
  (lambda (s lst errvalue)
    (if (null? list)
	errvalue
	(if (eq? s (car lst))
	    'car
	    (let ((result (car&cdr2-helper s (cdr lst)
					   (list 'compose 'cdr))))
	      (if (null? result)
		  errvalue 
		  result
		  )
	      ) ))
    ))
(car&cdr2 'a '(a b c) 'fail)
(car&cdr2 'c '(a b c) 'fail)
(car&cdr2 'dog '(cat lion (fish dog) pig) 'fail)
(car&cdr2 'a '(b  c) 'fail)

;; Page 79
;; Exercise 4
(define list-last
  (lambda (lst)  
    (if (null? (cdr lst))
	(car lst)
	(list-last (cdr lst))
     )
    ))
(define list-remove-helper
  (lambda (lst)
    (if (null? (cdr lst))
	'()
	(cons (car lst) (list-remove-helper (cdr lst)))
       )
    ))
(define compose-helper
  (lambda (proc-lst param-lst)
    (if (null? proc-lst)
	param-lst
	(let ((proc (list-last proc-lst))
	      (new-proc-lst (list-remove-helper proc-lst))
	      )
	  ;; (display proc)
	  ;; (newline)
	  ;; (display new-proc-lst)
	  ;; (proc param-lst)
	  (compose-helper new-proc-lst (proc param-lst)) 
	  )	
	)
    ))
(define compose
  (lambda proc-lst
    (lambda (param-lst)
      (if (null? proc-lst)
	  param-lst
	  (compose-helper  proc-lst param-lst)
	  )
      ) 
    ))
((compose) '(a b c d))
((compose car) '(a b c d))
((compose car cdr cdr) '(a b c d))

;; Exerciese 5








