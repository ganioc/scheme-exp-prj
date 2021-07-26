;; (import (rnrs))
(import (chezscheme))

(let ([args (cdr (command-line))])
  (unless (null? args)
    (let-values ([(newline? args)
		  (if (equal? (car args) "-n")
		      (values #f (cdr args))
		      (values #t args))])
      (do ([args args (cdr args)] [sep "" " "])
	  ((null? args))
	(printf "~a~a" sep (car args)))
      (when newline? (newline)))))

