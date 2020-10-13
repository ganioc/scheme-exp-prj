(define (acronym phrase)
  (accumulate word (every first phrase)))

(define (real-word? wd)
  (not (member? wd '(a the an in of and for to with))))

(define (acronym1 phrase)
  (accumulate word (every first (keep real-word? phrase))))

(acronym1 '(structure and interpretation of computer programs))
(acronym1 '(association for computing machinery))

(real-word? 'structure)

(real-word? 'of)

(define (pigl wd)
  (if (member? (first wd) 'aeiou)
      (word wd 'ay)
      (pigl (word (butfirst wd) (first wd)))))
(pigl 'spaghetti)
(pigl 'ok)

(define (rotate wd)
  (word (butfirst wd) (first wd)))

(rotate 'spaghetti)

(every pigl '(the ballad of john and yoko))
