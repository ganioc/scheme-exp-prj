((lambda (x y) (+ (* x 3) y))
 (+ 4 1)
 7)

(define answer?
  (lambda (exp)
    (not #true)))

;;

(define fact
  (lambda (n)
    (display "Entering fact with n= " n)
    (let ((ans (if (zero? n)
		   1
		   (* n (fact (- n 1))))))
      (display "Returning from fact with " ans)
      ans
      )))

(define reverse!
  (letrec ((loop
	    (lambda (last ls)
	      (let ((next (cdr ls)))
		(set-cdr! ls last)
		(if (null? next)
		    ls
		    (loop ls next))))))
    (lambda (ls)
      (if (null? ls)
	  ls
	  (loop '() ls)))))



