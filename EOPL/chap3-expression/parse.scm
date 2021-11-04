(load "error.scm")  ; redefine so we don't get Scheme's error
(load "record.scm") ; macros for define-record and variant-case

(define-record lit (datum))
(define-record varref (var))
(define-record lambda (formal body))
(define-record app (rator rand))

(define parse
  (lambda (datum)
    (cond
     ((number? datum) (make-lit datum))
     ((symbol? datum) (make-varref datum))
     ((pair? datum) (if (eq? (car datum) 'lambda)
                        (make-lambda (caadr datum) (parse (caddr datum)))
                        (make-app (parse (car datum)) (parse (cadr datum)))))
     (else (error 'parse "Invalid concrete syntax ~s" datum)))))

