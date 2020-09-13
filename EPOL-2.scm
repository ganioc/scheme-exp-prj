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
	(f a b))
      )))
((( curry2 display) "Fu Hao") "Wu Ding")

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
	(append ((list-ref (car lst) 0) (list-ref (car lst) 1) )
	      (invert (cdr lst))))
    )
  )

(define samplelst '((a 1) (a 2) (b 1) (b 2)))
samplelst
(invert '((a 1) (a 2) (b 1) (b 2)))

(display samplelst)
(display (cdar samplelst))
(display (caar samplelst))
( (cdar samplelst) (caar samplelst))


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


