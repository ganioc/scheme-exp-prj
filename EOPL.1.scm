(- 100 2)

(if #t 1 3)

(zero? 5)

(if (zero? 0)
    (if #f 2 3)
    4)

(eq? (boolean? #f) (not #f))
(not #f)
(boolean? #t)

;; char
(char? #\b)
(char=? #\newline #\space)
(char<? #\a  #\b)

;; string
(define s "This is a.")
s
(string? s)
(string->symbol s)
(string-length s)
(string-ref s 1)
(string #\a #\b)

(define x 3)
(symbol? x)
(symbol? 'x)
(cons 'a 'c)
(cons 'a '(c b))

(list 'a 'b 'c)
(append '(a b) '(c d e))
(append '(a b) '())

(null? '())

;; vector
(define v1 (vector 1 2 (+ 3 4)))
v1

(define v2 (quote #(a b)))
v2

(vector-length v1)
(vector-ref v1 0)

;; procedure
(procedure? 'car)
(procedure? car)
(symbol? 'car)


;; apply
(apply + '(1 2))

;; 1st class
(define compose
  (lambda (f g)
    (lambda (x)
      (f (g x)))))
(add2 1)
;; (define add4 (compose add2 add2))
;; (add4 5)

