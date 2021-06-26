;;; MzScheme macros implementing records for the book:
;;;
;;; "Essentials of Programming Languages", Daniel P. Friedman,
;;;   Mitchell Wand and Christopher T. Haynes, MIT Press, 1992.
;;;
;;; Code modified January 15, 1998 by Matthias Felleisen
;;; 1) every? replaced by andmap to avoid namespace problems
;;;    andmap is a standard Scheme routine
;;; 2) define-record simplified with h/o function and in-lining
;;; 3) variant-case simplified  by in-lining and renaming
;;; 4) added test code (see end of file)
;;;
;;; Three changes 2000-02-03 Max Hailperin <max@gac.edu>:
;;; 1) Put the (print-struct #t) at the top of the file,
;;;    which causes records (i.e., structs) to be printed
;;;    out more or less the way shown in the EOPL book,
;;;    rather than opaquely w/ just the type visible.
;;;    For more compact output, you can always do
;;;    (print-struct #f).
;;; 2) Silenced the test stuff at the end, which was
;;;    always printing something out, at least the string.
;;; 3) Silenced define-record (made it return void rather than
;;;    the record name) by analogy w/ define.
;;;
;;; (variant-case code Based on code of David McCusker, Copyrighted in 1993)
;;; Code created October 21, 1997 by Dan Friedman.

;;; For behavioral specification see tests at end of file. 

(print-struct #t)

(define-macro define-record 
  (lambda (rec-name rec-fields)
    (let ((translate
            (lambda (token)
              (lambda (rec-name f)
                (string->symbol
                  (string-append
                    (symbol->string rec-name) token (symbol->string f)))))))
      `(begin
         ,@(append
             (list (list 'define-struct rec-name rec-fields))
             (map (lambda (f)
                    (list 'define
                      ((translate "->") rec-name f)
                      ((translate "-")  rec-name f)))
                  rec-fields)
             '((void)))))))

(define-macro variant-case
  (lambda (record-exp . clauses)
    (let*
      (;; -- silly abbreviations
       (sym string->symbol)
       (str symbol->string)
       (cat string-append)
       ;; -- real stuff
       (exp (gensym))
       (make-clause
         (lambda (c)
           (let* ((name (str (car c)))
                  (n-f (lambda (f) (list f (list (sym (cat name "-" (str f))) exp)))))
             (if (eq? 'else (car c))
                 c
                 (list (list (sym (cat name "?")) exp)
                       (cons 'let (cons (map n-f (cadr c)) (cddr c)))))))))
      (for-each
        (lambda (c)
          (unless (and (pair? c)
                    (or (eq? 'else (car c))
                        (and (symbol? (car c))
                          (pair? (cdr c))
                          (list? (cadr c))
                          (andmap symbol? (cadr c)))))
            (error "variant-case: expected (name fields* ...); given: ~s" c)))
        clauses)
      `(let ((,exp ,record-exp))
         (cond
           ,@(map make-clause clauses))))))

(begin  
  ; in addition to moving the quote, you need to take the (begin ... (void)) out -max
  "Tests:
In DrScheme, should see same values in repl. Otherwise run and compare. 
To test: remove quotes at end of file and put one right here ->

(define-record bar (x))
'bar
(define-record foo (man chu))
'foo
(display
  (variant-case (make-bar 2)
    (foo (man chu) (cons man chu))
    (bar (x) x)
    (else (list 1))))
= 2
(display
  (variant-case (make-foo 1 2)
    (foo (man chu) (cons man chu))
    (bar (x) x)
    (else (list 1))))
= '(1 . 2)
(display 
  (variant-case 'go
    (foo (man chu) (cons man chu))
    (bar (x) x)
    (else (list 1))))
'(1)
"
  (void))