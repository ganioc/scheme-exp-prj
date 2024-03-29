;; Standard Scheme does not support records
;; But ChezScheme do support define-record and extend-syntax

(define record-proc-names
  (lambda (name fields)
    (let ((name-str (symbol->string name)))
      (cons
       (string->symbol
	(string-append	 (symbol->string 'make-)
	 name-str))
       (cons (string->symbol
	      (string-append
	       name-str
	       "?"))
	     (map (lambda (field)
		    (string->symbol
		     (string-append
		      name-str
		      "->"
		      (symbol->string field))))
		  fields))))))

(define record-indices
  (lambda (vec-len)
    (letrec
	((loop (lambda (i)
		 (if (= i vec-len)
		     '()
		     (cons i
			   (loop (+ i 1)))))))
      (loop 1))))

(define make-unique-name
  (lambda (names)
    (string->symbol
     (apply string-append
	    (map symbol->string names)))))

;; sigma
(extend-syntax
 (sigma)
 [(sigma (x ...) e1 e2 ...)
  (with ([(t ...)
	  (map (lambda (x) (gensym))
	       '(x ...))])
	(lambda (t ...)
	  (set! x t) ...
	  e1 e2 ...))])

;; define-my-structure
(extend-syntax
 (define-my-structure)
 [(define-my-structure (name id1 ...))
  (define-my-structure (name id1 ...) ())]
 [(define-my-structure (name id1 ...)
    ([id2 val] ...))
  (with ([constructor
	  (string->symbol (format "make-~a" 'name))]
	 [predicate
	  (string->symbol (format "~a?" 'name))]
	 [(access ..)
	  (map (lambda (x)
		 (string->symbol
		  (format "~a-~a" 'name x)))
	       '(id1 ... id2 ...))]
	 [(assign ...)
	  (map (lambda (x)
		 (string->symbol
		  (format "set-~a-~a!" 'name x)))
	       '(id1 ... id2 ...))]
	 [count
	  (length '(name id1 ... id2 ...))])
	(with ([(index ...)
		(let f ([i 1])
		  (if (= i 'count)
		      '()
		      (cons i (f (+ i 1)))))])
	      (begin
		(define constructor
		  (lambda (id1 ...)
		    (let* ([id2 val] ...)
		      (vector 'name id1 ... id2 ...)
		      )))
		(define predicate
		  (lambda (obj)
		    (and (vector? obj)
			 (= (vector-length obj)
			    count)
			 (eq? (vector-ref obj 0)
			      'name))))
		(define access
		  (lambda (obj)
		    (vector-ref obj index)))
		...
		(define assign
		  (lambda (obj newval)
		    (vector-set! obj
				 index
				 newval)))
		...)))]
 
 )

;; variant-case
(extend-syntax
 (variant-case else)
 [(variant-case var)
  (error "variant-case: no clause matches" var)]
 [(variant-case var (else exp1 exp2 ...))
  (begin exp1 exp2 ...)]
 [(variant-case exp clause ...)
  (not (symbol? 'exp))
  (with ((var (gensym)))
	(let ((var exp))
	  (variant-case var clause ...)))]
 [(variant-case var (name (field ...) exp1 exp2 ...) clause ...)
  (with (((make-name name? name->field ...)
	  (record-proc-names 'name '(field ...))))
	(if (name? var)
	    (let ((field (name->field var)) ...)
	      exp1
	      exp2
	      ...)
	    (variant-case var clause ...)))]
 )

;; define-record
(extend-syntax
 (define-record)
 ((define-record name (field ...))
  (with (((make-name name? name->field ...)
	  (record-proc-names 'name '(field ...)))
	 (unique-name
	  (make-unique-name '(name field ...)))
	 (vec-len (+ 1 (length '(field ...)))))
	(with (((i ...)
		(record-indices 'vec-len)))
	      (begin
		(define make-name
		  (let ((unique-name vector))
		    (lambda (field ...)
		      (unique-name 'name field ...))))
		(define name?
		  (lambda (obj)
		    (and (vector? obj)
			 (= (vector-length obj)
			    vec-len)
			 (eq? (vector-ref obj 0)
			      'name))))
		(define name->field
		  (lambda (obj)
		    (if (name? obj)
			(vector-ref obj i)
			(error (string-append
				(symbol->string 'name)
				"->"
				(symbol->string 'field)
				": bad record")
			       obj))))
		...)))))
