(define (element-of-set? x set)
  (cond ((null? set) false)
	((equal? x (car set)) true)
	(else (element-of-set? x (cdr set))))
  )

(define (adjoin-set x set)
  (if (element-of-set? x set)
      set
      (cons x set)))

(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
	((element-of-set? (car set1) set2)
	 (cons (car set1)
	       (intersection-set (cdr set1)
				 set2)))
	(else (intersection-set (cdr set1)
				set2))))

(define (union-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
	((element-of-set? (car set1) set2)
	 (cons (car set1)
	       (union-set (cdr set1)
			  (cdr set2))))
	(else
	  (cons (car set1)
		(union-set (cdr set1)
			   set2)))))
;; vertion 2
(define (element-of-set?-2 x set)
  (cond ((null? set) false)
	((= x (car set)) true)
	((< x (car set)) false)
	(else element-of-set?-2 x (cdr set))))

(define (intersection-set-2 set1 set2)
  (if (or (null? set1) (null? set2))
      '()
      (let ((x1 (car set1))
	    (x2 (car set2)))
	(cond ((= x1 x2)
	       (cons x1
		     (intersection-set-2 (cdr set1)
					 (cdr set2))))
	      ((< x1 x2)
	       (intersection-set-2 (cdr set1) set2))
	      ((< x2 x1)
	       (intersection-set-2 set1 (cdr set2)))))))

;; version 3
;; with balanced tree , list structure
(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

(define (element-of-set?-3 x set)
  (cond ((null? set) false)
	((= x (entry set)) true)
	((< x (entry set))
	 (element-of-set?-3 x
			    (left-branch set)))
	((> x (entry set))
	 (element-of-set?-3 x
			    (right-branch set)))))

(define (adjoin-set-3 x set)
  (cond ((null? set) (make-tree x '() '()))
	((= x (entry set)) set)
	((< x (entry set))
	 (make-tree (entry set)
		    (adjoin-set-3 x
				  (left-branch set))
		    (right-branch set)))
	((> x (entry set))
	 (make-tree (entry set)
		    (left-branch set)
		    (adjoin-set-3 x
				  (right-branch set))))))
;; Exercise 2.63
;;
(define (tree->list-1 tree)
  (if (null? tree)
      '()
      (append (tree->list-1 (left-branch tree))
	      (cons (entry tree)
		    (tree->list-1
		     (right-branch tree))))))
(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
	result-list
	(copy-to-list
	 (left-branch tree)
	 (cons (entry tree)
	       (copy-to-list
		(right-branch tree)
		result-list)))))
  (copy-to-list tree '()))

;; Exercise 2.64
;;
(define (list->tree elements)
  (car (partial-tree elements
		     (length elements))))

(define partial-tree
  (trace-lambda
   partial-tree
   (elts n)
   (if (= n 0)
       (cons '() elts)
       (let ((left-size (quotient (- n 1) 2)))
	 (let ((left-result (partial-tree elts left-size)))
	   (let ((left-tree (car left-result))
		 (non-left-elts (cdr left-result))
		 (right-size (- n (+ left-size 1))))
	     (let ((this-entry (car non-left-elts))
		   (right-result (partial-tree
				  (cdr non-left-elts)
				  right-size)))
	       (let ((right-tree (car right-result))
		     (remaining-elts (cdr right-result)))
		 (cons (make-tree this-entry
				 left-tree
				 right-tree)
		       remaining-elts)))))))))


