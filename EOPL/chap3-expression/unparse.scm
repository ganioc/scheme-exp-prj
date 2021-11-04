(define unparse
  (lambda (exp)
    (variant-case exp
                  (lit (datum) datum)
                  (varref (var) var)
                  (lambda (formal body)
                    (list 'lambda (list formal) (unparse body)))
                  (app (rator rand) (list (unparse rator) (unparse rand)))
                  (else (error 'unparse  ": Invalid abstract syntax ~d" 
                               exp )))))
