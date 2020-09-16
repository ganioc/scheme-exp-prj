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




