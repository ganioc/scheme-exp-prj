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

(load "./appendix.scm")

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
		      (interior->left-tree tree))
		     (leaf-sum
		      (interior->right-tree tree))))
		 (else
		  (error "leaf-sum: Invalid tree"
			 tree))
		 )))

(define-record leaf (number))

(define tree-2
  (make-interior 'foo
		 (make-interior 'bar
				(make-leaf 4)
				(make-leaf 2))
		 (make-leaf 3)))

(define leaf-sum-2
  (trace-lambda
   leaf-sum-2 (tree)
   (cond
    ((leaf? tree) (leaf->number tree))
    ((interior? tree)
     (+ (leaf-sum-2
	 (interior->left-tree tree))
	(leaf-sum-2
	 (interior->right-tree tree))))
    (else
     (error "leaf-sum-2: Invalid tree"
	    tree)))))

;; use variant-case
(define leaf-sum-vari
  (trace-lambda
   leaf-sum-vari (tree)
   (variant-case tree
		 (leaf (number) number)
		 (interior (left-tree right-tree)
			   (+ (leaf-sum-vari left-tree)
			      (leaf-sum-vari right-tree)))
		 (else
		  (error "leaf-sum-vari: Invalid tree"
			 tree)))))

;; use leaf-sum
(define leaf-sum-vari-2
  (trace-lambda
   leaf-sum-vari-2
   (tree)
   (let ((*record* tree))
     (cond
      ((leaf? *record*)
       (let ((number (leaf->number *record*)))
	 number))
      ((interior? *record*)
       (let ((left-tree (interior->left-tree *record*))
	     (right-tree (interior->right-tree *record*)))
	 (+ (leaf-sum-vari-2 left-tree)
	    (leaf-sum-vari-2  right-tree))))
      (else
       (error "leaf-sum-vari-2: Invalid tree" tree))))))


;; Exercise 3.4.3
;; max-interior,
(define tree-a (make-interior 'a (make-leaf 2)
			      (make-leaf 3)))
(define tree-b (make-interior 'b (make-leaf -1)
			      tree-a))
(define tree-c (make-interior 'c tree-b
			      (make-leaf 1)))

(define max-interior-helper
  (trace-lambda
   max-interior
   (tree)
   (cond
    ((leaf? tree)
     (let ((number (leaf->number tree)))
       number
       ))
    ((interior? tree)
     (let ((left-max (max-interior-helper
		      (interior->left-tree tree)))
	   (right-max (max-interior-helper
		       (interior->right-tree tree))))
       (if (> left-max right-max)
	   left-max
	   right-max)))
    (else
     (error "max-interior-helper: Invalid tree" tree))
    )))

(define-record tree-value (symbol value))

(define max-value
  (trace-lambda
   max-value
   (tree symbol)
   (cond
    ((leaf? tree)
     (let ((number (leaf->number tree)))
       (make-tree-value symbol number))
     )
    ((interior? tree)
     (let ((left-max (max-value (interior->left-tree tree)
				(interior->symbol tree)))
	   (right-max (max-value (interior->right-tree tree)
				 (interior->symbol tree))))
       (if (> (tree-value->value left-max)
	      (tree-value->value right-max))
	   left-max
	   right-max)
       ))
    (else
     (error "max-value : Invalid tree" tree))
    )))

(define max-interior
  (lambda (tree)

    (tree-value->symbol
     (max-value tree (interior->symbol tree))
     )))

;; Exercise 3.4.3
;;
(define-record lit (datum))
(define-record varref (var))
(define-record lambda (formal body))
(define-record app (rator rand))

(define parse
  (lambda (datum)
    (cond
     ((number? datum) (make-lit datum))
     ((symbol? datum) (make-varref datum))
     ((pair? datum)
      (if (eq? (car datum) 'lambda)
	  (make-lambda (caadr datum)
		       (parse (caddr datum)))
	  (make-app (parse (car datum))
		    (parse (cadr datum)))))
     (else
      (error "parse: Invalid concrete syntax" datum)))))

(define unparse
  (lambda (exp)
    (variant-case
     exp
     (lit (datum) datum)
     (varref (var) var)
     (lambda (formal body)
       (list 'lambda (list formal)
	     (unparse body)))
     (app (rator rand) (list (unparse rator)
			     (unparse rand)))
     (else
      (error "unparse: Invalid abstract syntax" exp)))))

(define free-vars
  (lambda (exp)
    (variant-case
     exp
     (lit (datum) '())
     (varref (var) (list var))
     (lambda (formal body)
       (remove formal (free-vars body)))
     (app (rator rand)
	  (union (free-vars rator)
		 (free-vars rand))))))
;; Finite Function, FF
;;
(define create-empty-ff
  (lambda ()
    (lambda (symbol)
      (error "empty-ff: no association for symbol" symbol))))

(define extend-ff
  (lambda (sym val ff)
    (lambda (symbol)
      (if (eq? symbol sym)
	  val
	  (apply-ff ff symbol)))))

(define apply-ff
  (lambda (ff symbol)
    (ff symbol)))


;; Data Representation
(define-record empty-ff ())
(define-record extended-ff (symbol val ff))

(define create-empty-ff-d
  (lambda ()
    (make-empty-ff)))

(define extend-ff-d
  (lambda (sym val ff)
    (make-extended-ff sym val ff)))

(define apply-ff-d
  (lambda (ff symbol)
    (variant-case
     ff
     (empty-ff ()
	       (error "empty-ff: no assocation to symbol" symbol))
     (extended-ff (sym val ff)
		  (if (eq? symbol sym)
		      val
		      (apply-ff-d ff symbol)))
     (else
      (error "apply-ff: Invalid finite function" ff)))))

(define create-empty-ff make-empty-ff)
(define extend-ff make-extended-ff)

(define dxy-ff
  (extend-ff
   'd 6
   (extend-ff
    'x 7
    (extend-ff
     'y 8
     (create-empty-ff)))))

(define extend-ff*
  (lambda (sym-list val-list ff)
    (if (null? sym-list)
	ff
	(extend-ff (car sym-list) (car val-list)
		   (extend-ff* (cdr sym-list)
			       (cdr val-list)
			       ff)))))











