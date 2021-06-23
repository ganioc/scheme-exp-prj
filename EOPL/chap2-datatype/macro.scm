;; Macro
(define-syntax myor
  (lambda (x)
    (syntax-case x ()
      ((_) (syntax #f))
      ((_ e) (syntax e))
      ((_ e1 e2 e3 ...)
       (syntax (let ((t e1))
		 (if t t
		     (myor e2 e3 ...))))))))

(define-syntax mysyntax-rules
  (lambda (x)
    (syntax-case x ()
      ((_ (i ...) ((keyword . pattern) template) ...)
       (syntax (lambda (x)
		 (syntax-case x (i ...)
		   ((dummy . pattern) (syntax template))
		   ...)))))))


(define-syntax mycond
  (lambda (x)
    (syntax-case x ()
      ((_ (e0 e1 e2 ...))
       (and (identifier? (syntax e0))
	    (free-identifier=? (syntax e0) (syntax else)))
       (syntax (begin e1 e2 ...)))
      ((_ (e0 e1 e2 ...)) (syntax (if e0 (begin e1 e2 ...))))
      ((_ (e0 e1 e2 ...) c1 c2 ...)
       (syntax (if e0 (begin e1 e2 ...) (mycond c1 c2 ...)))))))

