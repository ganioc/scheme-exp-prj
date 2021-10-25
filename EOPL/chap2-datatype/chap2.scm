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





