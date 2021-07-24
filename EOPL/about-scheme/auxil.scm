;; Auxiliaries for define-record and variant-case


;; (record-proc-names 'animal '(go no))
;; (make-animal animal? animal->go animal->no animal->retreat
(define record-proc-names
  (lambda (name fields)
    ;; (symbol, list-of-symbol)
    (let ((name-str (symbol->string name)))
      (cons (string->symbol (string-append
			     (symbol->string 'make-)
			     name-str))
	    (cons (string->symbol (string-append name-str "?"))
		  (map (lambda (field)
			 (string->symbol
			  (string-append
			   name-str
			   "->"
			   (symbol->string field))))
		       fields))))))

;;  (record-indices 6)
;; (1 2 3 4 5)
(define record-indices
  (lambda (vec-len)
    (letrec ((loop (lambda (i)
		     (if (= i vec-len)
			 '()
			 (cons i (loop (+ i 1)))))))
      (loop 1))))

;; (make-unique-name '(a bc de))  
;;  abcde
(define make-unique-name
  (lambda (names)
    (string->symbol
     (apply string-append (map symbol->string names)))))

;; A.2 Implementation of variant-case and define-record
(extend-syntax (variant-case else)
	       [(variant-case var) (error "variant-case: no clause matches" var)]
	       [(variant-case var (else exp1 exp2 ...))
				(begin exp1 exp2 ...)]
	       [(variant-case exp clause ...)
				(not (symbol? 'exp))
				(with ((var (gensym)))
		      	(let ((var exp)) (variant-case var clause ...)))]
	       [(variant-case var (name (field ...) exp1 exp2 ...) clause ...)
		(with (((make-name name? name->field ...)
			(record-proc-names 'name '(field ...))))
		      (if (name? var)
			  (let ((field (name->field var)) ...) exp1 exp2 ...)
			  (variant-case var clause ...)))]
	       )
(extend-syntax (define-record)
       [(define-record name (field ...))
		(with (((make-name name? name->field ...)
			(record-proc-names 'name '(field ...)))
		       (unique-name (make-unique-name '(name field ...)))
		       (vec-len (+ 1 (length '(field ...)))))
		      (with (((i ...) (record-indices 'vec-len)))
			    (begin
			      (define make-name
				(let ((unique-name vector))
				  (lambda (field ...)
				    (unique-name 'name field ...))))
			      (define name?
				(lambda (obj)
				  (and (vector? obj)
				       (= (vector-length obj) vec-len)
				       (eq? (vector-ref obj 0) 'name))))
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
			      ...)))])


(define-record lit (datum))

(define-record varref (var))
		      
(define-record app (rator rands))

(define eval-exp)

;; defining macros
(define-syntax mywhen
  (syntax-rules ()
    ((_ condition exp ...)
     (if condition
	 (begin exp ...)))))

(define-syntax myunless
  (syntax-rules ()
    ((_ condition exp ...)
     (if (not condition)
	 (begin exp ...)))))

(define-syntax myand
  (syntax-rules ()
    ((_) #t)
    ((_ e) e)
    ((_ e1 e2 e3 ...)
     (if e1 (and e2 e3 ...) #f))))

(define-syntax myor
  (syntax-rules ()
    ((_) #f)
    ((_ e) e)
    ((_ e1 e2 e3 ...)
     (let ((t e1))
       (if t t (or e2 e3 ...))))))

(define-syntax mylet
  (syntax-rules ()
    ((_ ((x v) ...) e1 e2 ...)
     ((lambda (x ...) e1 e2 ...) v ...))))

(define-syntax mylet*
  (syntax-rules ()
    ((_ ((x1 v1)) e1 e2 ...)
     (let ((x1 v1))
       (begin e1 e2 ...)))
    ((_ ((x1 v1) (x2 v2) ...) e1 e2 ...)
     (let ((x1 v1))
       (mylet* ((x2 v2) ...) e1 e2 ...)))))

(letrec ([even?
	  (lambda (x)
	    (or (= x 0)
		(odd? (- x 1 ))))]
	 [odd?
	  (lambda (x)
	    (and (not (= x 0))
		 (even? (- x 1))))])
  (list (even? 20) (odd? 20)))






