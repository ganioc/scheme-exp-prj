
(define (my-ttt position me)
  (cond ((i-can-win?)
	 (choose-winning-move))
	((opponent-can-win?)
	 (block-opponent-win))
	((i-can-win-next-time?)
	 (prepare-win))
	(else
	 (whatever)))
  )

(define (my-substitute-letter square position)
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

