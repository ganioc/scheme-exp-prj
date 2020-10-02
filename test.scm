
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
(define get-last-item
  (lambda (args) 
    (display "\nget-last-item\n")
    (pair? args)
    (length args)
    (display args)
    args
    (newline)
    (car args)
    ;; (display (car args))
    ;; ((car (car (args)))
    )
  )

(define do-work
  (lambda args 
    ;; ((car args) '(x y z))
    (if (pair? args)
	(display "Pair? true\n")
	(display "Not a pair\n")) 
    (length args)
    args
    ;;((get-last-item args) '(1 2 3))
    ((get-tail args) '(1 2 3))
    ))





