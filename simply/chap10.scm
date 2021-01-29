
;; (define (my-ttt position me)
;;   (cond ((i-can-win?)
;; 	 (choose-winning-move))
;; 	((opponent-can-win?)
;; 	 (block-opponent-win))
;; 	((i-can-win-next-time?)
;; 	 (prepare-win))
;; 	(else
;; 	 (whatever)))
;;   )

(define (my-substitute-letter square position)
  ;; if equals _ , return position, 
  (if (equal? '_ (item position square))
      position
      (item position square))
  )

(define (my-substitute-triple combination position)
  (accumulate word
	      (every (lambda (square)
		       (my-substitute-letter position  square ))
		     combination))
  )
(define (find-triples position)
  (every (lambda (comb) (substitute-triple comb position))
	 '(123 456 789 147 258 369 159 357)))

(define (opponent letter)
  (if (equal? letter 'x) 'o 'x))

;;
(define (my-pair? triple me)
(and (= (appearances me triple) 2)
     (= (appearances (opponent me) triple) 0)))

