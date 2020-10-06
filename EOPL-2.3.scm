;; Static properties of variables
;; 2.3.10

(define lexical-address
  (lambda (lst)
    lst
    ))

(lexical-address '(lambda (a b c)
		    (if (eq? b c)
			((lambda (c)
			   (cons a c))
			 a)
			b)))





