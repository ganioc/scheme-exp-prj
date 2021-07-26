(library (lib fibonacciex)
  (export fib-list)
  (import (rnrs)
	  (lib fibonacci))

  (define fib-list
    (lambda (n)
      (if (zero? n)
          '()
          (cons (fib n)
		(fib-list (- n 1))))))  
  )




