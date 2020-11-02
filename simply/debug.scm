
(define (cust_add num)
  (let ((base 10))
    (cond ((> num 10) (+ num base))
	  ((> num 100) (+ num (* 2 base)))
	  (else (- num base)))
    ))

(define (make-serial-number-generator)
  (let ((current-serial-number 0))
    (lambda ()
      (set! current-serial-number (+ current-serial-number 1))
      current-serial-number)))
(define entry-sn-generator (make-serial-number-generator))
(define entry-sn-generator2 (make-serial-number-generator))

(define get-balance #f)
(define deposit #f)

(let ((balance 0))
  (set! get-balance
    (lambda ()
      balance))
  (set! deposit
    (lambda (amount)
      (set! balance (+ balance amount))
      balance)))
(define (withdraw amount)
  (deposit (- amount)))


