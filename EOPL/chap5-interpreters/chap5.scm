(load "appendix.scm")

(define-record lit (datum))
(define-record varref (var))
(define-record app (rator rands))
(define-record lambda (formal body))
(define-record arr (data))

(define parse
  (trace-lambda
   parse
   (datum)
    (cond
     ((number? datum) (make-lit datum))
     ((symbol? datum) (make-varref datum))
     ((pair? datum)
      (if (eq? (car datum) 'lambda)
	  (make-lambda (caadr datum)
		       (parse (caddr datum)))
	  (make-app (parse (car datum))
		    (parse (cadr datum)))))
     (else
      (error "parse: Invalid concrete syntax" datum)))))

(define unparse
  (lambda (exp)
    (variant-case
     exp
     (lit (datum) datum)
     (varref (var) var)
     (lambda (formal body)
       (list 'lambda (list formal)
	     (unparse body)))
     (app (rator rand) (list (unparse rator)
			     (unparse rand)))
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
  (lambda (proc args)
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
     ;; ((add1) (+ (car args)  1))
     ;; ((sub1) (- (car args)  1))
     ((add1) (+ args  1))
     ((sub1) (- args  1))     
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
     (app (rator rands)
	  (let ((proc (eval-exp rator))
		(args (eval-exp rands)))
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
(define read-eval-print
  (lambda ()
    (display "-->")
    (write (eval-exp (parse (read))))
    (newline)
    (read-eval-print)))

