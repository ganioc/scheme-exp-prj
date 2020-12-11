(+ (+ 2 3) (+ 4 5))
(load "./code/simply.scm")

(define (two-firsts sent)
  (se (first (first sent))
      (first (last sent)))
  )
(two-firsts '(john lennon))

(define (first-letters sent)
  (every first sent))

(first-letters '(here comes the sun))

(define (always-one arg)
  1)

(define (count sent)
  (accumulate + (every always-one sent)))

(count '(the continuing story of bungalow bill))

(define (real-word? wd)
  (not (member? wd '(a the an in of and for to with))))

(define (acronym phrase)
  (accumulate word (every first (keep real-word? phrase))))
(acronym '(reduced instruction set computer))
(acronym '(structure and interpretation of computer programs))

((repeated bf 3) '(she came in through the bathroom window) )
;; (plural 'computer)

(define (add-three-to-each sent)
  (every (lambda (number) (+ number 3)) sent))

(add-three-to-each '(1 9 9 2))

(define (backwards wd)
  (accumulate (lambda (a b) (word b a)) wd)
  )
(backwards 'yesterday )


