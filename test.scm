
(define test
  (lambda args
    (display args)))

(define (show . args)
  (if (null? args)
      (display "Empty arg")
      (display args)
      )
  )
