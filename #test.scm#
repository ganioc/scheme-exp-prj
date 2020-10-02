
;; (define test
;;   (lambda args
;;     (display args)))

;; (define (show . args)
;;   (if (null? args)
;;       (display "Empty arg")
;;       (display args)
;;       )
;;   )

;; (define run
;;   (lambda args
;;     ((car args) '(x y z))
;;     ((cadr args) '(x y z))
;;     )
;;   )
(define get-tail
  (lambda (args)
    (if (null? (cdr args))
	(car args)
	(get-tail (cdr args)))
    ))
(define do-work
  (lambda args 
    ((get-tail args) '(1 2 3))
    ))





