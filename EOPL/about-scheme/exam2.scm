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
	   ;; 经过实验，发现确实不用set! return, 因为每次的return都是重新传入的，作为一个跳出call/cc的路径handler,
	   ;; (set! return
	   (call/cc
	   ;; 在这里嵌入一个continuation, 用函数名control-state来存储当前的执行位置。resume-here没有其它的用处，只是一个运行位置的表示;
	    (lambda (resume-here)
	      (set! control-state resume-here)
	      (return element))));; )
	 lst)
	(return 'empty-of-lst)
	))
    (lambda ()
      (call/cc control-state))
    ))
  
;; 接下来是一个 multitasking的例子
;;

(define ready-list '())

(define exit
  (let ((exit exit))
    (lambda ()
      (if (not (null? ready-list))
	  (let ((cont (car ready-list)))
	    (set! ready-list (cdr ready-list))
	    (cont #f))
	  (exit)))))

;; This is a lazy operation
(define (fork fn arg)
  (set! ready-list
    (append ready-list
	    (list
	     (lambda (x)
	       (fn arg)
	       (exit))))))


(define (yield)
  (call/cc
   (lambda (cont)
     (set! ready-list
       (append ready-list
	       (list cont)))

     (let ((cont (car ready-list)))
       (set! ready-list (cdr ready-list))
       (cont #f))))
  )

;; (let* ((yin
;; 	((lambda (cc)
;; 	   (display #\@)
;; 	   cc)
;; 	 (call/cc
;; 	  (lambda (c) c))))
;;        (yang
;; 	((lambda (cc)
;; 	   (display #\*)
;; 	   cc)
;; 	 (call/cc
;; 	  (lambda (c) c)))))
;;   (yin yang))


