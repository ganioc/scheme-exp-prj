;; 移花接木

(define dish #f)

(define (put! fruit) (set! dish fruit))
(define (get!) (let ([ fruit dish])
		 (set! dish #f)
		 fruit))

(define (consumer do-other-stuff)
  (let loop ()
    (when dish
      (printf "C: get a ~a~%" (get!))
      (set! do-other-stuff
	(call/cc do-other-stuff))
      (loop))
    ))

(define (producer do-other-stuff)
  (for-each
   (lambda (fruit)
     (put! fruit)
     (printf "P: put a ~a~%" fruit)
     (set! do-other-stuff
       (call/cc do-other-stuff)))
   '("apple" "pear" "strawberry" "peach" "grape")))

;; producer 往盘子里放水果之后，通过 call/cc 调用 consumer，它的 continuation 就传进 consumer 了（consumer 的 do-other-stuff 就是 producer 的 continuation）， consumer 取出水果之后，就能通过这个 continuation 回到 producer，同时它也把自己的 continuation 传给了 producer。两个函数通过互传 continuation 的方式实现切换和恢复

(define tree->generator
  (lambda (tree)
    (let ((caller '*))
      (letrec
	  ((generate-leaves
	    (lambda ()
	      (let loop ((tree tree))
		(cond ((null? tree) 'skip)
		      ((pair? tree)
		       (loop (car tree))
		       (loop (cdr tree)))
		      (else
		       (call/cc
			(lambda (rest-of-tree)
			  (set! generate-leaves
			    (lambda ()
			      (rest-of-tree 'resume)))
			  (caller tree))))))
	      (caller '()))))
	(lambda ()
	  (call/cc
	   (lambda (k)
	     (set! caller k)
	     (generate-leaves))))))))

(define same-fringe?
  (lambda (tree1 tree2)
    (let ((gen1 (tree->generator tree1))
	  (gen2 (tree->generator tree2)))
      (let loop ()
	(let ((leaf1 (gen1))
	      (leaf2 (gen2)))
	  (if (eqv? leaf1 leaf2)
	      (if (null? leaf1) #t (loop))
	      #f))))))

(define my-iterator 
  (lambda (lst)
    (define control-state
      (lambda (return)
	(for-each
	 (lambda (element)
	   ;; 为什么要在这里重新设置return呢?
	   (set! return
	     (call/cc
	      (lambda (resume-here)
		(set! control-state resume-here)
		(return element)))))
	 lst)
	(return 'empty-of-lst)
	))
    (lambda ()
      (call/cc control-state))
    ))
  
