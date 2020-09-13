(define add2
  (lambda (n)
    (+ n 2)))

(add2 1)

(define compose
  (lambda (f g)
    (lambda (x)
      (f (g x)))))

(define add4 (compose add2 add2))

;; implementation of cells


