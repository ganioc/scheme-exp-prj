;; chap3
(define subst
  (lambda (new old slst)
    (if (null? slst)
	'()
	(let ((car-value (car slst))
	      (cdr-result (subst new old (cdr slst))))
	  (if (symbol? car-value)
	      (if (eq? car-value old)
		  (cons new cdr-result)
		  (cons car-value cdr-result))
	      (cons (subst new old car-value)
		    cdr-result))))))

;; Exercise 3.1.2
(define let->application-helper
  (trace-lambda let->application-helper (lst)
		(cond
		 [(null? lst) '()]
		 [else
		  (cons (cadar lst)
			(let->application-helper
			 (cdr lst)))])))
(define let->application-collect
  (trace-lambda let->application-collect (lst)
		(cond
		 [(null? lst) '()]
		 [else
		  (cons (caar lst)
			(let->application-collect
			 (cdr lst)))])))

(define let->application
  (trace-lambda let->application (slst)
		(if (eqv? 'let (car slst))
		    (cons
		     (list 'lambda
			   (let->application-collect
			    (cadr slst))
			   (caddr slst))
		     (let->application-helper
			    (cadr slst))
		     )
		    '())
		))

;; Exercise 3.3.1
;;
(define if->cond-helper
  (trace-lambda if->cond-helper (slst)
		(if (not (list? slst))
		    (list (list 'else slst))
		    (let ((name-op (car slst))
			  (judge (cadr slst))
			  (true-op (caddr slst))
			  (false-op (cadddr slst)))
		      (if (eq? name-op 'if)
			  (cons (list judge true-op)
				(if->cond-helper false-op))
			  (list (list 'else false-op))
			  )
		      )
		    )
		))
(define if->cond
  (trace-lambda if->cond (slst)
		(if (null? slst)
		    '()
		    (cons 'cond 
			  (if->cond-helper slst)
			  ))
		))
;; (if->cond '(if a b c))
;;    > (cond [a b] [else c])
;; (if->cond '(if a b (if c d (if e f g))))
;;    > (cond [a b] [c d] [e f] [else g])
;; (if->cond '(if a (if x b c) (if d e f)))
;;    > (cond [a (if x b c)] [d e] [else f])

(define cond->if-helper
  (trace-lambda cond->if-helper (slst)
		(if (null? slst)
		    '()
		    (let ((cur-op (car slst))
			  (next-op (cdr slst)))
		      (if (and (symbol? (car cur-op) )
			       (eqv? (car cur-op) 'else ))
			  (cadr cur-op)
			  (list 
			   'if 
			   (car cur-op)
			   (cadr cur-op)
			   (cond->if-helper next-op)
			   )
			  )
		      )
		    )
		))
(define cond->if
  (trace-lambda cond->if (slst)
		(if (null? slst)
		    '()
		    (cond->if-helper (cdr slst) ))
		))
;; (cond->if '(cond (a b) (c d) (else e)))
;;    > (if a b (if c d e))

;; Exercise 3.3.2
;; case


(define-record interior (symbol left-tree right-tree))

(define tree-1 (make-interior 'foo
			      (make-interior 'bar
					     1
					     2)
			      3))

(define leaf-sum
  (trace-lambda leaf-sum (tree)
		(cond
		 ((number? tree) tree)
		 ((interior? tree)
		  (+ (leaf-sum
		      (interior-left-tree tree))
		     (leaf-sum
		      (interior-right-tree tree))))
		 (else
		  (error "leaf-sum: Invalid tree"
			 tree))
		 )))

(define-record leaf (number))

(define tree-2
  (make-interior 'foo
		 (make-interior 'bar
				(make-leaf 1)
				(make-leaf 2))
		 (make-leaf 3)))

(define leaf-sum-2
  (trace-lambda
   leaf-sum-2 (tree)
   (cond
    ((leaf? tree) (leaf-number tree))
    ((interior? tree)
     (+ (leaf-sum-2
	 (interior-left-tree tree))
	(leaf-sum-2
	 (interior-right-tree tree))))
    (else
     (error "leaf-sum-2: Invalid tree"
	    tree)))))

