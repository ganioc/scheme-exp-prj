;; (display 'helloworld)
(extend-syntax (rec)
	       [(rec id val) (let ([id #f])
				 (set! id val)
				 id)])

(rec num 18)

(extend-syntax (mywhen)
	       [(mywhen test exp1 exp2 ...)
		(if test (begin exp1 exp2 ...) #f)]
	       )

(mywhen #t (display 'hi) (display 'i))

(extend-syntax (mylet)
	       ((mylet ([x e] ...) b1 b2 ...)
		((lambda (x ...) b1 b2 ...) e ...)))

(mylet ([a 1] [b 2]) (display a) (display b))

(let ((c 2)) (display 2))

(extend-syntax (myand)
	       ((myand) #t)
	       ((myand x) x)
	       ((myand x y ...) (if x (myand y ...) #f))
	       )
(myand 1 2 3)

(extend-syntax (mycond else)
	       ((mycond) #f)
	       ((mycond (else e1 e2 ...))
		(begin e1 e2 ...))
	       ((mycond (test) more ...)
		(or test (mycond more ...)))
	       ((mycond (test e1 e2 ...) more ...)
		(if test
		    (begin e1 e2 ...)
		    (mycond more ...))))
(mycond )
(mycond (#t (display 1))
	(else (display 'e)))

(extend-syntax (sigma)
	       ((sigma (x ...) e1 e2 ...)
		(with ([(t ...) (map (lambda (x) (gensym))
				     '(x ...))])
		      (lambda (t ...)
			(set! x t) ...
			e1 e2 ...))))
(let ([x 'a] [y 'b])
  ((sigma (x y) (list x y)) y x))

(extend-syntax (define-structure)
	       [(define-structure (name id1 ...))
		(define-structure (name id1 ...) ())]
	       [(define-structure (name id1 ...) ([id2 val] ...))
		(with ([constructor
			(string->symbol (format "make-~a" 'name))]
		       [predicate
			(string->symbol (format "~a?" 'name))]
		       [(access ...)
			(map (lambda (x)
			       (string->symbol
				(format "~a-~a" 'name x)))
			     '(id1 ... id2 ...))]
		       [(assign ...)
			(map (lambda (x)
			       (string->symbol
				(format "set-~a-~a!" 'name x)))
			     '(id1 ... id2 ...))]
		       [count (length '(name id1 ... id2 ...))])
		      (with ([(index ...)
			      (let f ([i 1])
				(if (= i 'count)
				    '()
				    (cons i (f (+ i 1)))))])
			    (begin
			      (define constructor
				(lambda (id1 ...)
				  (let* ([id2 val] ...)
				    (vector 'name id1 ... id2 ...))))
			      (define predicate
				(lambda (obj)
				  (and (vector? obj)
				       (= (vector-length obj) count)
				       (eq? (vector-ref obj 0) 'name))))
			      (define access
				(lambda (obj)
				  (vector-ref obj index)))
			      ...
			      (define assign
				(lambda (obj newval)
				  (vector-set! obj index newval)))
			      ...)
			    )
		      )
		])
