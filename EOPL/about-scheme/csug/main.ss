(import (chezscheme)
	(lib fibonacci)
	(lib fibonacciex))

(display "What's up?\n")

(printf "~a~%" (fib 5))


(define main
  (lambda ()
    (printf "This is the main procedure~%")
    (printf "First, print fib(10) = ~a~%" (fib 10))
    (printf "First 11 Fibonacci numbers: ~a~%" (fib-list 11))))

;;; Initialize the program
(define initialize 
  (lambda fns 
    (printf "This procedures initializes the program.~%")))

;;; This will be called by the boot-file
(scheme-start
  (lambda fns
    (initialize fns)
    (main)))

(main)
