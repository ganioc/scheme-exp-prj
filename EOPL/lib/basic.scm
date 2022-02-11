(library (worker)
        (export make-worker)

(import (chezscheme))

(define (make-worker n)
        (lambda ()  (set! n (+ n 1))  n) )

) ;; end library worker
