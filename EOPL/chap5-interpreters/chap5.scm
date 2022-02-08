(load "appendix.scm")

(define-record lit (datum))
(define-record varref (var))
(define-record app (rator rands))

