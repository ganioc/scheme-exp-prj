;;; simple-extend.ss
;;; Copyright (C) 1987 R. Kent Dybvig
;;; Permission to copy this software, in whole or in part, to use this
;;; software for any lawful purpose, and to redistribute this software
;;; is granted subject to the restriction that all copies made of this
;;; software must include this copyright notice in full.

;;; The basic design of extend-syntax is due to Eugene Kohlbecker.  See
;;; "E. Kohlbecker: Syntactic Extensions in the Programming Language Lisp",
;;; Ph.D.  Dissertation, Indiana University, 1986."  The structure of "with"
;;; pattern/value clauses, the method for compiling extend-syntax into
;;; Scheme code, and the actual implementation are due to Kent Dybvig.


(letrec
   ([id (lambda (name access control) (list name access control))]
    [id-name car]
    [id-access cadr]
    [id-control caddr]
    [loop (lambda () (cons '() '()))]
    [loop-ids car]
    [loop-ids! set-car!]
    [parse
     (lambda (keys pat acc cntl ids)
        (cond
           [(symbol? pat)
            (if (memq pat keys)
                ids
                (cons (id pat acc cntl) ids))]
           [(pair? pat)
            (if (equal? (cdr pat) '(...))
                (let ([x (gensym)])
                   (parse keys (car pat) x (id x acc cntl) ids))
                (parse keys (car pat) `(car ,acc) cntl
                   (parse keys (cdr pat) `(cdr ,acc) cntl ids)))]
           [else ids]))]
    [gen
     (lambda (exp ids loops)
        (cond
           [(symbol? exp)
            (let ([x (mem (lambda (x) (eq? (id-name x) exp)) ids)])
               (if (null? x)
                   `',exp
                   (let ([id (car x)])
                      (add-control! (id-control id) loops)
                      (id-access id))))]
           [(pair? exp)
            (cond
               [(eq? (car exp) 'with)
                (unless (syntax-match? '(with) '(with ((p x) ...) e ...) exp)
                   (error 'extend-syntax "invalid 'with' form ~s" exp))
                (gen-with (map car (cadr exp))
                          (map cadr (cadr exp))
                          (caddr exp)
                          ids
                          loops)]
               [(equal? (cdr exp) '(...))
                (let ([x (loop)])
                   (make-loop x
                              (gen (car exp) ids (cons x loops))
                              (gen (cddr exp) ids loops)))]
               [else
                `(cons ,(gen (car exp) ids loops)
                       ,(gen (cdr exp) ids loops))])]
           [else exp]))]

    [gen-with
     (lambda (pats exps body ids loops)
        (if (null? pats)
            (gen body ids loops)
            (let ([p (car pats)] [e (car exps)] [g (gensym)])
               `(let ([,g ,(gen-quotes e ids loops)])
                   ,(gen-with (cdr pats)
                              (cdr exps)
                              body
                              (parse '() p g '() ids)
                              loops)))))]

    [gen-quotes
     (lambda (exp ids loops)
        (cond
           [(syntax-match? '(quote) '(quote x) exp)
            (gen (cadr exp) ids loops)]
           [(pair? exp)
            (cons (gen-quotes (car exp) ids loops)
                  (gen-quotes (cdr exp) ids loops))]
           [else exp]))]

    [add-control!
     (lambda (id loops)
        (unless (null? id)
           (let ([x (loop-ids (car loops))])
              (unless (memq id x)
                 (loop-ids! (car loops) (cons id x))
                 (add-control! (id-control id) (cdr loops))))))]

    [make-loop
     (lambda (loop body tail)
        (let* ([ids (loop-ids loop)]
               [exp `(map (lambda ,(map id-name ids) ,body)
                          ,@(map id-access ids))])
           `(append ,exp ,tail)))]

    [make-clause
     (lambda (keys clause x)
        (cond
           [(syntax-match? '() '(pat exp) clause)
            (let ([pat (car clause)] [exp (cadr clause)])
               (let ([ids (parse keys pat x '() '())])
                  `((syntax-match? ',keys ',pat ,x)
                    ,(gen exp ids '()))))]
           [(syntax-match? '() '(pat fdr exp) clause)
            (let ([pat (car clause)] [fdr (cadr clause)] [exp (caddr clause)])
               (let ([ids (parse keys pat x '() '())])
                  `((and (syntax-match? ',keys ',pat ,x)
                         ,(gen-quotes fdr ids '()))
                    ,(gen exp ids '()))))]
           [else
            (error 'extend-syntax "invalid clause ~s" clause)]))]

    [make-syntax
     (let ([x (make-temp-symbol "x")] [e (make-temp-symbol "e")])
        (lambda (keys clauses)
           `(lambda (,x ,e)
               (,e (cond
                      ,@(map (lambda (c) (make-clause keys c x)) clauses)
                      (else
                       (error ',(car keys) "invalid syntax ~s" ,x)))))))])

   (extend-syntax (extend-syntax)
      [(extend-syntax (key1 key2 ...) clause ...)
       (andmap symbol? '(key1 key2 ...))
       (with ([expander (make-syntax '(key1 key2 ...) '(clause ...))])
          (define-syntax-expander key1 expander))])

   (extend-syntax (extend-syntax/code)
      [(extend-syntax/code (key1 key2 ...) clause ...)
       (andmap symbol? '(key1 key2 ...))
       (with ([expander (make-syntax '(key1 key2 ...) '(clause ...))])
          'expander)]))

(define syntax-match?
   (rec match?
      (lambda (keys pat exp)
         (cond
            [(symbol? pat) (if (memq pat keys) (eq? exp pat) #t)]
            [(pair? pat)
             (if (equal? (cdr pat) '(...))
                 (recur f ([lst exp])
                    (or (null? lst)
                        (and (pair? lst)
                             (match? keys (car pat) (car lst))
                             (f (cdr lst)))))
                 (and (pair? exp)
                      (match? keys (car pat) (car exp))
                      (match? keys (cdr pat) (cdr exp))))]
            [else (equal? exp pat)]))))
