;;; fibonacci.ss
(library (lib fibonacci)
  (export fib)
  (import (rnrs))

  (define fib 
    (lambda (n)
      (if (<= n 2)
          1
          (+ (fib (- n 2)) (fib (- n 1))))))
  
  )





