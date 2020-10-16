(define (prepend-every item lst)
  (map (lambda (choice) (se item choice)) lst))

(define (choices menu)
  (if (null? menu)
      '(())
      (let ((smaller (choices (cdr menu))))
	(reduce append
		(map (lambda (item) (prepend-every item smaller))
		     (car menu))))))

(choices '((small medium large)
	   (vanilla (ultra chocolate) (rum raisin) ginger)
	   (cone cup)))

(define (combinations size set)
  (cond ((= size 0) '(()))
	((empty? set) '())
	(else (append (prepend-every (first set)
				     (combinations (- size 1)
						   (butfirst set)))
		      (combinations size (butfirst set))))))
(combinations 3 '(a b c d e))

(combinations 2 '(john paul george ringo))
(combinations 2 '(a b))
(combinations 2 '(a b c))
(combinations 2 '(a b c d))
