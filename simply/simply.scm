;;; simply.scm
;;; Based on berkeley.scm version.

(if (equal? 'foo (symbol->string 'foo))
    (error "Simply.scm already laoded!")
    #f)

;; number->string remove leading "+"
(if (char=? #\+ (string-ref (number->string 1.0) 0))
    (let ((old-ns number->string)
	  (char=? char=?)
	  (string-ref string-ref)
	  (substring substring)
	  (string-length string-length)
	  )
      (set! number->string
	(lambda args
	  (let ((result (apply old-ns args)))
	    (if (char=? #\+ (string-ref result 0))
		(substring result 1 (string-length result))
		result)
	    )))
      )
    'no-problem
    )

(define number->string
  (let ((old-ns number->string)
	(string? string?))
    (lambda args
      (if (string? (car args))
	  (car args)
	  (apply old-ns args)))
    ))

;; Get strings in error messages to print nicely (especially "")
(define whoops
  (let ((string? string?)
	(string-append string-append)
	(error error)
	(cons cons)
	(map map)
	(apply apply))
    (define (error-printform x)
      (if (string? x)
	  (string-append "\"" x "\"")
	  x)
      )
    (lambda (string . args)
      (apply error
	     (cons string (map error-printform args))))
    ))

(if (and (inexact? (round (sqrt 2))) (exact? 1))
    (let ((old-round round)
	  (inexact->exact inexact->exact))
      (set! round
	(lambda (number)
	  (inexact->exact (old-round number)))))
    'no-problem)

;; Remainder and quotient blow up if their argument isn'tan integer
(if (inexact? (* .25 4))
    (let ((rem remainder)
	  (quo quotient)
	  (inexact->exact inexact->exact)
	  (integer? integer?))
      (set! remainder
	(lambda (x y)
	  (rem (if (integer? x) (inexact->exact x) x)
	       (if (integer? y) (inexact->exact y) y)
	       )
	  ))
      (set! quotient
	(lambda (x y)
	  (quo (if (integer? x) (inexact->exact x) x)
	       (if (integer? y) (inexact->exact y) y))))
      )
    'done)

;; Random
(define random
  (let ((*seed* 1)
	(quotient quotient)
	(modulo modulo)
	(+ +)
	(- -)
	(* *)
	(> >))
    (lambda (x)
      (let* ((hi (quotient *seed* 127773))
	     (low (modulo *seed* 127773))
	     (test (- (* 16807 low) (* 2836 hi))))
	(if (> test 0)
	    (set! *seed* test)
	    (set! *seed* (+ test 2147483647)))
	)
      (modulo *seed* x)
      )
    )
  )

;; Logo style word/sentence implementations
(define word?
  (let ((number? number?)
	(symbol? symbol?)
	(string? string?))
    (lambda (x)
      (or (symbol? x) (number? x) (string? x))
      )
    )
  )

(define sentence?
  (let ((null? null?)
	(pair? pair?)
	(word? word?)
	(car car)
	(cdr cdr))
    (define (list-of-words? l)
      (cond ((null? l) #t)
	    ((pair? l)
	     (and (word? (car l))
		  (list-of-words? (cdr l))))
	    (else #f)))
    list-of-words?
    ))

;; 0 Letter in good case or special initial
;; 1 .,+ or -
;; 2 Digit
;; 3 Letter in bad case or weird character
(define char-rank
  (let ((*the-char-ranks* (make-vector 256 3))
	(= =)
	(+ +)
	(string-ref string-ref)
	(string-length string-length)
	(vector-set! vector-set!)
	(char->integer char->integer)
	(symbol->string symbol->string)
	(vector-ref vector-ref))
    (define (rank-string str rank)
      (define (helper i len)
	(if (= i len)
	    'done
	    (begin (vector-set! *the-char-ranks*
				(char->integer (string-ref str i))
				rank)
		   (helper (+ i 1) len))))
      (helper 0 (string-length str)))
    (rank-string (symbol->string 'abcdefghijklmnopqrstuvwxyz) 0)
    (rank-string "!$%&*/:<=>?~_^" 0)
    (rank-string "+-." 1)
    (rank-string "0123456789" 2)
    (lambda (char)
      (vector-ref *the-char-ranks* (char->integer char)))
    ))

(define string->word
  )
