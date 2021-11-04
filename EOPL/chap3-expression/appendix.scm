;; Standard Scheme does not support records
;; But ChezScheme do support define-record and extend-syntax

(define record-proc-names
  (lambda (name fields)
    (let ((name-str (symbol->string name)))
      (cons
       (string->symbol
	(string->append
	 (symbol->string 'make-)
	 name-str))
       (cons (string->symbol
	      (string-append
	       name-str
	       "?"))
	     (map (lambda (field)
		    (string->symbol
		     (string->append
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

(extend-syntax
 (variant-case else)
 
 )
