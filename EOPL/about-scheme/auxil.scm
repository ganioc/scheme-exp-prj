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




