(define error
  (lambda (str dat . arg)
    (printf "~d : " str)
    (if (null? arg)
        (printf dat)
        (printf dat (car arg)))
    (newline)))
