;; (duple n x) returns a list containing n copies of x
(define duple
  (lambda  (x n)
    (if (eq? x 0)
	'()
	(cons n (duple (- x 1) n)))
    ))

(define invert
  (lambda (lst)
    (if (null? lst)
	'()
	(let ([a (car lst)])
	  (cons  (cons (car (cdr a))  (car a) ) 
		(invert (cdr lst)))))))
(define cust-list-index
  (lambda (s los n)
    (if (null? los)
	-1
	(if (eq? s (car los))
	    n
	    (cust-list-index s (cdr los) (+ 1 n)))
	) 
    ))

(define list-index
  (lambda ( s los)
    (cust-list-index s los 0)
    ))
(define cust-list-ref
  (lambda (los index n)
    (if (eq? index n)
	(car los)
	(cust-list-ref (cdr los) index (+ 1 n)))
    ))

(define list-ref
  (lambda (los index)
    (cust-list-ref los index 0)
    ))

(define cust-vector-index
  (lambda (s vec index)
    (if (= 0 (vector-length vec))
	'()
	(if (eq? s (vector-ref vec index))
	    index
	    (cust-vector-index s vec (+ 1 index))))
    ))

(define vector-index
  (lambda (s vec)
    (cust-vector-index s vec 0)
    ))

(define ribassoc
  (lambda (s lst vec msg)
    (let* ((index (list-index s lst)))
      (if (= index -1)
	  msg
	  (let ((fb (vector-ref vec index)))
	  (if (null? fb)
	      msg
	      fb)
	  )))))

(define remove-first
  (lambda (s los)
    (if (null? los)
	'()
	(if (eq? (car los) s)
	    (cdr los)
	    (cons (car los) (remove-first s (cdr los)))))))

(define remove
  (lambda (s los)
    (if (null? los)
	'()
	(if (eq? (car los) s)
	    (remove s (cdr los))
	    (cons (car los) (remove s (cdr los)))))))

(define partial-vector-sum
  (lambda (von n)
    (if (zero? n)
	0
	(+ (vector-ref von (- n 1))
	   (partial-vector-sum von (- n 1))))))

(define vecotr-sum
  (lambda (von)
    (partial-vector-sum von (vector-length von))))

;;> (down '(1 2 3))                                                            ;;   ((1) (2) (3))
;;
;;> (down '(a (more (compolicated)) object))                                   ;;   ((a) ((more (compolicated))) (object))
;;
(define down
  (lambda (lst)
    (if (null? lst)
	'()
	(cons (cons (car lst) '())
	      (down (cdr lst))))))


;;  (up '((x (y)) z))
;;  (x (y) z)
(define up
  (trace-lambda up (lst)
		(if (null? lst)
		    '()
		    (if (list? (car lst))
			(append (car lst) (up (cdr lst) ))
			(append (list (car lst)) (up (cdr lst)))
			))))


(define half
  (trace-lambda half (x)
		(cond
		 [(zero? x) 0]
		 [(odd? x) (half (- x 1))]
		 [(even? x) (+ (half (- x 1)) 1)])))


(define count-occurrences
  (trace-lambda count-occurrences (s slst)
		(if (null? slst)
		    0
		    (if (list? (car slst))
			(+ (count-occurrences s (car slst))
			   (count-occurrences s (cdr slst)))
			(if (equal? s (car slst))
			    (+ 1 (count-occurrences s (cdr slst)))
			    (+ 0 (count-occurrences s (cdr slst))))
			))))

;; Exercise 2.2.8
;; 4
(define flatten
  (trace-lambda flatten (slst)
		(if (null? slst)
		    '()
		    (if (list? slst)
			(if (list? (car slst))
			    (append (flatten (car slst))
				    (flatten (cdr slst)))
			    (append (list (car slst))
				    (flatten (cdr slst)))
			    )
			(list slst)
			))
		))

;; Exercise 2.2.8
;; 5
(define merge
  (trace-lambda merge (lon1 lon2)
		(cond
		 [(null? lon1) lon2]
		 [(null? lon2) lon1]
		 [(> (car lon1) (car lon2))
		  (append (list (car lon2))
			  (list (car lon1))
			  (merge (cdr lon2) (cdr lon1)))]
		 [else
		  (append (list (car lon1))
			  (list (car lon2))
			  (merge (cdr lon1) (cdr lon2)))]
		 )
		))

;; Exercise 2.2.9
;; 1
;; (define path-checker
;;   (trace-lambda path-checker (n bst lst-container)
;; 		(if (null? bst)
;; 		    '()
;; 		    (if (equal? n (car bst))
;; 			lst-container
			
;; 			)
;; 		    ;; if left not empty
		    

;; 		    ;; if right not empty

;; 		    ;; retrun '()
		    
;; 		    )))
;; (define path-helper
;;   (trace-lambda path-helper (n bst lst-container)
;; 		(if (null? bst)
;; 		    '()
;; 		    (begin
;; 		      (printf "~a\n" (car bst))
;; 		      (if (equal? n (car bst))
;; 			  lst-container
			  
;; 			  )
;; 		      (path-helper n (cadr bst) lst-container)
;; 		      (path-helper n (caddr bst) lst-container)
			
;; 			))
;; 		))
;; binary search tree, 是按照大小分的，所以不需要全部检索
;; 这个是我没有理解，无法做出来的原因。
(define path
  (trace-lambda path (n bst)
		(if (null? bst)
		    '()
		    (let ([head (car bst)])
		      (if (< n head)
			  (cons 'L (path n (cadr bst)))
			  (if (equal? n head)
			      '()
			      (cons 'R (path n (caddr bst)))))
		      ))))
;;					
;; 这是一个很好的算法，来自网上
;; github.com/rubenbarroso/EOPL/1.17
(define path1
  (trace-lambda path1 (n bst)
		(letrec ((finder
			  (lambda (tree the-path)
			    (cond
			     [(null? tree) '()]
			     [(= (car tree) n) the-path]
			     [else
			      (let ((found-left
				     (finder (cadr tree)
					     (append the-path
						     '(left)))))
				(if (not (null? found-left))
				    found-left
				    (finder (caddr tree)
					    (append the-path
						    '(right)))))]))))
		  (finder bst '()))))

;; return the code to get s from slst
;; otherwiser return errvalue
(define car&cdr-helper
  (trace-lambda car&cdr-helper (s slst errvalue container)
		(if (null? slst)
		    errvalue
		    (if (equal? (car slst) s)
			(list 'car container)
			(if (list? (car slst))
			    (car&cdr-helper s (car slst)
					    errvalue
					    (list 'car container))
			    (car&cdr-helper s (cdr slst)
					    errvalue
					    (list 'cdr container))
			    )
			)		    
		    )
		))
(define car&cdr
  (trace-lambda car&cdr (s slst errvalue)
		(list 'lambda (list 'lst)
		      (car&cdr-helper s slst errvalue 'lst
			      ))
		))

;; 这是一个完美的解答, 2021-10-24,
;; 用到了letrec, 对遇到的每一个list,返回结果，letrec可以保存
;; 中间值；最后再把结果美化后输出!
(define carcdr
  (trace-lambda carcdr (s slst errvalue)
		(letrec ((finder
			  (lambda (slst container)
			    (cond
			     [(null? slst) '()]
			     [(not (list? (car slst)))
			      (if (equal? s (car slst))
				  (list 'car container)
				  (finder (cdr slst)
					  (list 'cdr container))

				  )
			      ]
			     [else
			      (let ((found
				     (finder (car slst)
					     (list 'car
						   container))))
				(if (not (null? found))
				    found
				    (finder (cdr slst)
					    (list 'cdr
						  container))))
			      ]))))
		  (let ((out (finder slst 'lst)))
		    (if (null? out)
			errvalue
			(list 'lambda '(lst) out))
		    )
		  )
		))

;; (car&cdr 'a '(a b c) 'fail)
;; >    (lambda (lst) (car lst))
;; (car&cdr 'c '(a b c) 'fail)
;; >    (lambda (lst) (car (cdr (cdr lst))))
;;
;; 我并没有完全的解决这种题型，从分叉中跳出还是没有实现
;; 也许要在递归中使用continuation才行
;; (car&cdr 'dog '(cat lion (fish dog) pig) 'fail)
;; >    (lambda (lst) (car (cdr (car (cdr (cdr lst))))))

(define car&cdr2-helper
  (trace-lambda car&cdr2-helper (s slst errvalue container)
		(if (null? slst)
		    '()
		    (if (equal? s (car slst))
			(list 'compose 'car
			      (cons 'compose container))
			(car&cdr2-helper s (cdr slst)
					 errvalue
					 (cons 'cdr container))
			)
		    )
		))
(define car&cdr2
  (trace-lambda car&cdr2 (s slst errvalue)
		(if (equal? s (car slst))
		    'car
		    (car&cdr2-helper s slst errvalue '()))
		))

;; 3.
;; 这是一个凑出来的答案，实际上不是很优美。
(define carcdr2
  (trace-lambda carcdr2 (s slst errvalue)		
		(letrec ((finder
			  (trace-lambda finder (lst container)
			    (cond
			     [(null? lst) '()]
			     [(not (list? (car lst)))
			      (if (equal? s (car lst))
				  (if (null? container)
				      'car
				      (list 'compose 'car  container) 
				      )
				  (finder (cdr lst)
					  (if (null? container)
					      (list 'compose 'cdr)
					      (if (and (equal? 'compose (car container))
						       (equal? 'cdr (cadr container))
						       ) 
						  (append container '(cdr))
						  (list 'compose 'cdr container)
					      )
					  )))]
			     [else
			      (let ((found
				     (finder (car lst)
					     (list 'compose
						   'car
						   container))))
				(if (not (null? found)) 
				    found
				    (finder (cdr lst)
					    (list 
						  'cdr
						  container)))
				)
			      ]))))
		  (let ((out (finder slst '()))) 
		    (if (null? out)
			errvalue
			out))
		  )
		))

;; It's not perfectlly solved
;; I will leave it here for later studying ...

;; EOPL 2, Exercise 1.17, 
;; 4
;;
(define reverse
  (trace-lambda reverse (lst)
		(if (null? lst)
		    '()
		    (append (reverse (cdr lst)) (list ( car lst))))))
(define compose
  (trace-lambda compose args 
    (display (list? args))
    (display #\newline)

    (letrec ((operate (lambda (cmds arglst)
			(if (null? cmds)
			    arglst
			    (operate (cdr cmds)
				     ((car cmds) arglst)))
			)))
      (if (null? args)
	  (lambda (x)
	    x)
	  (lambda (x)
	  (operate (reverse args) x))
	  )
      )
    ))

;; 5
(define filterin
  (trace-lambda filterin (pred lst)
		(cond
		 [(null? lst) '()]
		 [(pred (car lst))
		  (cons (car lst) (filterin pred (cdr lst)))]
		 [else
		  (filterin pred (cdr lst))])))
(define sort
  (trace-lambda sort (lst)
		(define less-than
		  (lambda (n)
		    (lambda (x)
		      (< x n))))
		(define greater-or-equal-than
		  (lambda (n)
		    (lambda (x)
		      (>= x n))))
		(if (null? lst)
		    '()
		    (append (sort (filterin (less-than (car lst))
					    (cdr lst)))
			    (list ( car lst))
			    (sort (filterin (greater-or-equal-than (car lst))
					    (cdr lst)))))
		))

;; 6
(define sort
  (trace-lambda sort (predicate lst)
		(define less-than
		  (lambda (n)
		    (lambda (x)
		      (predicate x n))))
		(define greater-or-equal-than
		  (lambda (n)
		    (lambda (x)
		      (not (predicate x n)))))
		(letrec ((operate
			  (lambda (lst)
			    (if (null? lst)
				'()
				(append (operate (filterin (less-than (car lst))
							   (cdr lst)))
					(list (car lst))
					(operate (filterin (greater-or-equal-than (car lst))
							   (cdr lst))))
				
				)

			    )))
		  (operate lst)
		  )
		))



;; 2.3.1
;; Page 57,
;; 
(define occurs-free?
  (lambda (var exp)
    (cond
     [(symbol? exp) (eqv? var exp)]
     [(eqv? (car exp) 'lambda)
      (and (not (eqv? (caadr exp) var))
	   (occurs-free? var (caddr exp)))]
     [else (or (occurs-free? var (car exp))
	       (occurs-free? var (cadr exp)))])))

(define occurs-bound?
  (lambda (var exp)
    (cond
     [(symbol? exp) #f]
     [(eqv? (car exp) 'lambda)
      (or (occurs-bound? var (caddr exp))
	  (and (eqv? (caadr exp) var)
	       (occurs-free? var (caddr exp))))]
     [else (or (occurs-bound? var (car exp))
	       (occurs-bound? var (cadr exp)))]
     )))

;; filter-in
(define filter-in
  (lambda (pred lst)
    (cond
     [(null? lst) '()]
     [(pred (car lst))
      (cons (car lst) (filter-in pred (cdr lst)))]
     [else
      (filter-in pred (cdr lst))])))
;; 收集所有的变量
(define extract-vars
  (lambda (exp)
    (define collector
      (lambda (exp vars)
	(cond
	 [(symbol? exp)
	  (if (not (memq exp vars))
	      (cons exp vars))]
	 [(eqv? (car exp) 'lambda)
	  (collector (caddr exp) vars)]
	 [else
	  (append (collector (car exp) vars)
		  (collector (cadr exp) vars))])))
    (collector exp '())
    ))

(define free-vars
  (lambda (exp)
    (filter-in (lambda (var)
		 (occurs-free? var exp))
	       (extrac-vars exp))))

(define bound-vars
  (lambda (exp)
    (filter-in (lambda (var)
		 (occurs-bound? var exp))
	       (extract-vars exp))))

;; 2.3.10
;;
(define make-lexical-address
  (lambda (v d p)
    (list v ': d p)))
;; (make-lexical-address 'a 1 0)                                                
;; (a : 1 0)

(define get-v
  (lambda (address)
    (car address)))
(define get-d
  (lambda (address)
    (caddr address)))
(define get-p
  (lambda (address)
    (cadddr address)))
;; 增加 depth
(define increment-depth
  (lambda (address)
    (make-lexical-address (get-v address)
			  (+ 1 (get-d address))
			  (get-p address))))

;; 获取 exp 在 一个list中的address, 
(define get-lexical-address
  (lambda (exp addresses)
    (define iter
      (lambda (lst)
		(cond 
			[(null? lst) (list exp 'free)]
	      	[(eqv? exp (get-v (car lst))) (car lst)]
	      	[else
	       		(get-lexical-address exp (cdr lst))])
	))
    (iter addresses)))

;; 在list中查找v, 找到就返回调用cdr的次数;也就是在list中的位置
(define index-of
  (lambda (v declarations)
    (define helper
      (lambda (lst index)
	(cond
	 [(null? lst) 'free]
	 [(eqv? (car lst) v) index]
	 [else
	  (helper (cdr lst) (+ index 1))]
	 )))
    (helper declarations 0)))
;; 找到declarations所有的变量,
(define filter-bound
  (lambda (declarations)
    (map (lambda (decl)
	   (make-lexical-address decl
				 0
				 (index-of decl declarations)))
	 declarations)))
;; 找到addresses中,不在declarations里面的那些变量,
(define filter-free
  (lambda (declarations addresses)
    (define iter
      (lambda (lst)
	(cond
	 [(null? lst) '()]
	 [(not (memq (get-v (car lst)) declarations))
	  (cons (increment-depth (car lst))
		(iter (cdr lst)))
	  ]
	 [else
	  (iter (cdr lst))
	  ]
	 )))
    (iter addresses)))
;; 
(define cross-contour
  (trace-lambda cross-contour (declarations addresses)
    (let ((bound (filter-bound declarations))
		  (free (filter-free declarations addresses)))
      (append bound free))))
;; 
(define lexical-address-helper
  (trace-lambda lexical-address-helper (exp addresses)
		(cond
    		 [(symbol? exp)
      		(get-lexical-address exp addresses)]
     		 [(eqv? (car exp) 'if)
      		  (list 'if
	    		(lexical-address-helper (cadr exp) addresses)
	    		(lexical-address-helper (caddr exp) addresses)
	    		(lexical-address-helper (cadddr exp) addresses))]
     		 [(eqv? (car exp) 'lambda)
      		  (list 'lambda
			(cadr exp)
			(lexical-address-helper (caddr exp)
						(cross-contour (cadr exp)
						   	       addresses)))]
     		 [else
      		  (map (lambda (subex)
	     		 (lexical-address-helper subex addresses))
		       exp)]
		 )))

(define lexical-address
  (lambda (exp)
    (lexical-address-helper exp '())
    ))
;; (get-variable '(: 0 1) '((a : 1 0) (b : 0 1) (c : 1 1)))
;; > b
(define get-variable
  (trace-lambda get-variable (exp addresses)
    (cond
     [(eqv? 'free (cadr exp))
      (car exp)]
     [(null? addresses)
      #f]
     [(and (eqv? (cadr exp)
		 (get-d (car addresses)))
	   (eqv? (caddr exp)
		 (get-p (car addresses))))
      (get-v (car addresses))]
     [else
      (get-variable exp (cdr addresses))])
    ))

(define reference?
  (lambda (exp)
    (eqv? ': (car exp))))

;;
(define un-lexical-address-helper
  (trace-lambda un-lexical-address-helper (exp addresses)
    (cond
     [(reference? exp)
      (get-variable exp addresses)]
     [(eqv? (car exp) 'if)
      (let ((condition
	     (un-lexical-address-helper (cadr exp) addresses))
	    (consequent
	     (un-lexical-address-helper (caddr exp) addresses))
	    (alternative
	     (un-lexical-address-helper (cadddr exp) addresses)))
	(if (or
	     (not condition)
	     (not consequent)
	     (not alternative))
	    #f
	    (list 'if condition consequent alternative)))]
     [(eqv? (car exp) 'lambda)
      (let ((lambda-body
	     (un-lexical-address-helper (caddr exp)
					(cross-contour (cadr exp)
						       addresses))))
	(if (not lambda-body)
	    #f
	    (list 'lambda
		  (cadr exp)
		  lambda-body)))]
     [else
      (map (lambda (subexp)
	     (un-lexical-address-helper subexp addresses))
	   exp)]
     )))

(define un-lexical-address
  (lambda (exp)
    (un-lexical-address-helper exp '())))


;; Exercise 2.3.14
;; rename
;; (rename '(lambda (b) (b a)) 'c 'a)
;;    > (lambda (b) (b c))
;; (rename '((lambda (x) x) x) 'y 'x)
;;    > ((lambda (x) x) y)
;; 还是有问题啊，对这个的理解还是不够深！看以后回来再解决这个问题吧。
(define rename
  (trace-lambda rename (exp replace origin)
		(letrec
		    ((helper
		      (trace-lambda helper (exp scope)
			(cond
			 [(symbol? exp)
			  (if (and (eqv? exp origin)
				   (occurs-free? exp scope))
			      replace
			      exp)]
			 [(eqv? (car exp) 'lambda)
			  (list 'lambda
				(helper (cadr exp) scope) 
				(helper (caddr exp) scope))]
			 [else
			  (map (lambda (subex)
				 (helper subex subex))
			       exp)]
			 ))))
		  (helper exp exp)
		  )
		))

