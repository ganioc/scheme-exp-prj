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


(define (lookup given-key set-of-records)
  (cond ((null? set-of-records) false)
	((equal? given-key (key (car set-of-records)))
	 (car set-of-records))
	(else (lookup given-key (cdr set-of-records)))))

;; Huffman Trees
;; 分为叶子节点, 树节点
(define (make-leaf symbol weight)
  (list 'leaf symbol weight))
(define (leaf? object)
  (eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))
(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))
(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))
(define (make-code-tree left right)
  (list left
	right
	(append (symbols left)
		(symbols right))
	(+ (weight left) (weight right))))
(define (weight-tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))
(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))
;; decode
;; 解码
(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
	((= bit 1) (right-branch branch))
	(else
	 (error "bad bit -- CHOOSE-BRANCH" bit))))

(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
	'()
	(let ((next-branch
	       (choose-branch (car bits) current-branch)))
	  (if (leaf? next-branch)
	      (cons (symbol-leaf next-branch)
		    (decode-1 (cdr bits) tree))
	      (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

(define (adjoin-set x set)
  (cond ((null? set) (list x))
	((< (weight x) (weight (car set)))
	 (cons x set))
	(else (cons (car set)
		    (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
	(adjoin-set (make-leaf (car pair)
			       (cadr pair))
		    (make-leaf-set (cdr pairs))))))

(define sample-tree
  (make-code-tree (make-leaf 'A 4)
		  (make-code-tree (make-leaf 'B 2)
				  (make-code-tree
				   (make-leaf 'D 1)
				   (make-leaf 'C 1)))))

(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

(define (encode-symbol symbol tree)
  (define (hit-leaf branch)
    (and (eq? 2 (car branch))
	 (null? (cdr branch))))
  (define (check-node node)
    (let ((left (check (left-branch node))))
      (if (not (null? left))
	  (if (hit-leaf left)
	      '(0)
	      (append '(0) left))
	  (let ((right (check (right-branch node))))
	    (if (not (null? right))
		(if (hit-leaf right)
		    '(1)
		    (append '(1) right))
		'())))))
  (define (check node)
    (if (leaf? node)
	(if (eq? symbol (symbol-leaf node))
	    '(2)
	    '())
	(check-node node)))
  (check-node tree))

(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
	      (encode (cdr message) tree))))

;; Exercise 2.69
;;
(define (generate-huffman-tree pairs)
  (display 'he)
  )

