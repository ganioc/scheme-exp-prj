(load "appendix.scm")

(import (apdx character-parse))

;; concrete syntax
(define-record lit (datum))
(define-record varref (var))
(define-record app (rator rands))
(define-record lambda (formals body))
(define-record if (test-exp then-exp else-exp))

(define parse
  (trace-lambda
   parse
   (datum)
    (cond
     ((number? datum) (make-lit datum))
     ((symbol? datum) (make-varref datum))
     ((pair? datum)
      (let ((operator (car datum)) )
	(cond
	 ((eq? operator 'lambda)
	  (make-lambda (map parse (cadr datum)) 
		       (caddr datum)))
	 ((eq? operator 'if)
	  (make-if (parse (cadr datum))
		   (parse (caddr datum))
		   (parse (cadddr datum))))
	 (else (make-app (parse (car datum))
			 (map parse (cdr datum))))
	)))
     (else
      (error "parse: Invalid concrete syntax" datum)))))

(define unparse
  (lambda (exp)
    (variant-case
     exp
     (lit (datum) datum)
     (varref (var) var)
     (lambda (formal body)
       (list 'lambda
	     (map unparse formal)
	     (unparse body)))
     (if (test-exp then-exp else-exp)
	 (list 'if
	       (unparse test-exp)
	       (unparse then-exp)
	       (unparse else-exp)))
     (app (rator rand) (list (unparse rator)
			     (map unparse rand)))
     (else
      (error "unparse: Invalid abstract syntax" exp)))))

;; Finite Function, FF
;;
(define-record empty-ff ())
(define-record extended-ff (sym val ff))

(define create-empty-ff
  (lambda ()
    (make-empty-ff)))
    ;; (lambda (symbol)
    ;;   (error "empty-ff: no association for symbol" symbol))))

(define extend-ff
  (lambda (sym val ff)
    (make-extended-ff sym val ff)))

;; list of symbols, list of values, a finite function,ff
(define extend-ff*
  (lambda (sym-list val-list ff)
    (if (null? sym-list)
	ff
	(extend-ff (car sym-list) (car val-list)
		   (extend-ff* (cdr sym-list)
			       (cdr val-list)
			       ff)))))

(define apply-ff
  (lambda (ff symbol)
    (variant-case
     ff
     (empty-ff ()
	       (error "empty-ff: no association for symbol" symbol))
     (extended-ff (sym val ff)
		(if (eq? symbol sym)
		    val
		    (apply-ff ff symbol)))
     (else
      (error "apply-ff: Invalid finite function" ff)))))

(define the-empty-env (create-empty-ff))
(define extend-env extend-ff*)
(define apply-env apply-ff)

(define-record prim-proc (prim-op))

(define apply-proc
  (trace-lambda
   apply-proc
   (proc args)
    (variant-case
     proc
     (prim-proc (prim-op) (apply-prim-op prim-op
					 args))
     (else (error "Invalid procedure:" proc)))))
;; args should be a list
(define apply-prim-op
  (trace-lambda
   apply-prim-op
   (prim-op args)
   (case prim-op
     ((+) (+ (car args) (cadr args)))
     ((-) (- (car args) (cadr args)))
     ((*) (* (car args) (cadr args)))
     ((add1) (+ (car args)  1))
     ((sub1) (- (car args)  1))
     ;; ((add1) (+ args  1))
     ;; ((sub1) (- args  1))     
     (else (error "Invalid prim-op name: " prim-op)))))

(define prim-op-names '(+ - * add1 sub1))

(define init-env
  (extend-env
   prim-op-names
   (map make-prim-proc prim-op-names)
   the-empty-env))

;; Simple Interpreter
(define eval-exp
  (trace-lambda
   eval-exp
   (exp)
    (variant-case
     exp
     (lit (datum) datum)
     (varref (var) (apply-env init-env var))
     (if (test-exp then-exp else-exp)
	 (let ((test-val (eval-exp test-exp))
	       (then-val (eval-exp then-exp))
	       (else-val (eval-exp else-exp)))
	   (if test-val
	       then-val
	       else-val)))
     (app (rator rands)
	  (let ((proc (eval-exp rator))
		(args (eval-rands rands)))
	    (apply-proc proc args)))
     (else
	  (error "Invalid abstract syntax: " exp)
      ))))

(define eval-rands
  (lambda (rands)
    (map eval-exp rands)))

(define run
  (lambda (x)
    (eval-exp (parse x))))

;; Exercise 5.1.1
;; parse还是有问题的
;; 现在可以了！0218
(define read-eval-print
  (lambda ()
    (display "-->")
    (write (eval-exp (parse (read))))
    (newline)
    (read-eval-print)))

