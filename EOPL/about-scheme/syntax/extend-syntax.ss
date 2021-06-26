;;; extend.ss
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

(let ()
   (define id
      (lambda (name access control)
         (list name access control)))
   (define id-name car)
   (define id-access cadr)
   (define id-control caddr)

   (define loop
      (lambda ()
         (box '())))
   (define loop-ids unbox)
   (define loop-ids! set-box!)

   (define c...rs
      `((car caar . cdar)
        (cdr cadr . cddr)
        (caar caaar . cdaar)
        (cadr caadr . cdadr)
        (cdar cadar . cddar)
        (cddr caddr . cdddr)
        (caaar caaaar . cdaaar)
        (caadr caaadr . cdaadr)
        (cadar caadar . cdadar)
        (caddr caaddr . cdaddr)
        (cdaar cadaar . cddaar)
        (cdadr cadadr . cddadr)
        (cddar caddar . cdddar)
        (cdddr cadddr . cddddr)))

   (define add-car
      (lambda (access)
         (let ([x (and (pair? access) (assq (car access) c...rs))])
            (if x
                `(,(cadr x) ,@(cdr access))
                `(car ,access)))))

   (define add-cdr
      (lambda (access)
         (let ([x (and (pair? access) (assq (car access) c...rs))])
            (if x
                `(,(cddr x) ,@(cdr access))
                `(cdr ,access)))))

   (define checkpat
      (lambda (keys pat exp)
         (let ([vars (let f ([x pat] [vars '()])
                        (cond
                           [(pair? x)
                            (if (and (pair? (cdr x))
                                     (eq? (cadr x) '...)
                                     (null? (cddr x)))
                                (f (car x) vars)
                                (f (car x) (f (cdr x) vars)))]
                           [(symbol? x)
                            (cond
                               [(memq x keys) vars]
                               [(or (eq? x 'with) (eq? x '...))
                                (error 'extend-syntax
                                       "invalid context for ~s in ~s"
                                       x exp)]
                               [else (cons x vars)])]
                           [else vars]))])
            (let ([dupls (\#duplicate-symbols vars)])
               (unless (null? dupls)
                  (error 'extend-syntax
                         "duplicate pattern variable name ~s in ~s"
                         (car dupls)
                         exp))))))
   (define parse
      (lambda (keys pat acc cntl ids)
         (cond
            [(symbol? pat)
             (if (memq pat keys)
                 ids
                 (cons (id pat acc cntl) ids))]
            [(pair? pat)
             (cons (id pat acc cntl)
                   (if (equal? (cdr pat) '(...))
                       (let ([x (gensym)])
                          (parse keys (car pat) x (id x acc cntl) ids))
                       (parse keys (car pat) (add-car acc) cntl
                          (parse keys (cdr pat) (add-cdr acc) cntl ids))))]
            [else ids])))

   (define pattern-variable?
      (lambda (sym ids)
         (memq sym (map id-name ids))))

   (define gen
      (lambda (keys exp ids loops qqlev)
         (cond
            [(lookup exp ids) =>
             (lambda (id)
                (add-control! (id-control id) loops)
                (list 'unquote (id-access id)))]
            [(not (pair? exp)) exp]
            [else
             (cond
                [(and (syntax-match? '(quasiquote *) exp)
                      (not (pattern-variable? 'quasiquote ids)))
                 (list 'unquote
                       (list 'list
                             ''quasiquote
                             (make-quasi
                                (gen keys (cadr exp) ids loops
                                     (if (= qqlev 0) 0 (+ qqlev 1))))))]
                [(and (syntax-match? '(* *) exp)
                      (memq (car exp) '(unquote unquote-splicing))
                      (not (pattern-variable? (car exp) ids)))
                 (list 'unquote
                       (if (= qqlev 1)
                           (gen-quotes keys (cadr exp) ids loops)
                           (list 'list
                                 (list 'quote (car exp))
                                 (make-quasi
                                    (gen keys (cadr exp) ids loops
                                         (- qqlev 1))))))]
                [(and (eq? (car exp) 'with)
                      (not (pattern-variable? 'with ids)))
                 (unless (syntax-match? '(with ((* *) ...) *) exp)
                    (error 'extend-syntax "invalid 'with' form ~s" exp))
                 (checkpat keys (map car (cadr exp)) exp)
                 (list 'unquote
                    (gen-with
                       keys
                       (map car (cadr exp))
                       (map cadr (cadr exp))
                       (caddr exp)
                       ids
                       loops))]
                [(and (pair? (cdr exp)) (eq? (cadr exp) '...))
                 (let ([x (loop)])
                    (gen-cons (list 'unquote-splicing
                                    (make-loop x (gen keys (car exp) ids
                                                      (cons x loops) qqlev)))
                              (gen keys (cddr exp) ids loops qqlev)))]
                [else
                 (gen-cons (gen keys (car exp) ids loops qqlev)
                           (gen keys (cdr exp) ids loops qqlev))])])))

   (define gen-cons
      (lambda (head tail)
         (if (null? tail)
             (if (syntax-match? '(unquote-splicing *) head)
                 (list 'unquote (cadr head))
                 (cons head tail))
             (if (syntax-match? '(unquote *) tail)
                 (list head (list 'unquote-splicing (cadr tail)))
                 (cons head tail)))))

   (define gen-with
      (lambda (keys pats exps body ids loops)
         (let ([temps (map (lambda (x) (gensym)) pats)])
            `(let (,@(map (lambda (t e) `[,t ,(gen-quotes keys e ids loops)])
                          temps
                          exps))
                ,@(let f ([ps pats] [ts temps])
                     (if (null? ps)
                         (let f ([pats pats] [temps temps] [ids ids])
                            (if (null? pats)
                                `(,(make-quasi (gen keys body ids loops 0)))
                                (f (cdr pats)
                                   (cdr temps)
                                   (parse '() (car pats) (car temps) '() ids))))
                         (let ([m (match-pattern '() (car ps))])
                            (if (eq? m '*)
                                (f (cdr ps) (cdr ts))
                                `((unless (syntax-match? ',m ,(car ts))
                                     (error ',(car keys)
                                            "~s does not fit 'with' pattern ~s"
                                            ,(car ts)
                                            ',(car ps)))
                                  ,@(f (cdr ps) (cdr ts)))))))))))

   (define gen-quotes
      (lambda (keys exp ids loops)
         (cond
            [(syntax-match? '(quote *) exp)
             (make-quasi (gen keys (cadr exp) ids loops 0))]
            [(syntax-match? '(quasiquote *) exp)
             (make-quasi (gen keys (cadr exp) ids loops 1))]
            [(pair? exp)
             (let f ([exp exp])
                (if (pair? exp)
                    (cons (gen-quotes keys (car exp) ids loops)
                          (f (cdr exp)))
                    (gen-quotes keys exp ids loops)))]
            [else exp])))

   (define lookup
      (lambda (exp ids)
         (let loop ([ls ids])
            (cond
               [(null? ls) #f]
               [(equal? (id-name (car ls)) exp) (car ls)]
               [(subexp? (id-name (car ls)) exp) #f]
               [else (loop (cdr ls))]))))

   (define subexp?
      (lambda (exp1 exp2)
         (and (symbol? exp1)
              (let f ([exp2 exp2])
                 (or (eq? exp1 exp2)
                     (and (pair? exp2)
                          (or (f (car exp2))
                              (f (cdr exp2)))))))))

   (define add-control!
      (lambda (id loops)
         (unless (null? id)
            (when (null? loops)
               (error 'extend-syntax "missing ellipsis in expansion"))
            (let ([x (loop-ids (car loops))])
               (unless (memq id x)
                  (loop-ids! (car loops) (cons id x))))
            (add-control! (id-control id) (cdr loops)))))

   (define make-loop
      (lambda (loop body)
         (let ([ids (loop-ids loop)])
            (when (null? ids)
               (error 'extend-syntax "extra ellipsis in expansion"))
            (cond
               [(equal? body (list 'unquote (id-name (car ids))))
                (id-access (car ids))]
               [(and (null? (cdr ids))
                     (syntax-match? '(unquote (* *)) body)
                     (eq? (cadadr body) (id-name (car ids))))
                `(map ,(caadr body) ,(id-access (car ids)))]
               [else
                `(map (lambda ,(map id-name ids) ,(make-quasi body))
                      ,@(map id-access ids))]))))

   (define match-pattern
      (lambda (keys pat)
         (cond
            [(symbol? pat)
             (if (memq pat keys)
                 (if (memq pat '(* \\ ...))
                     `(\\ ,pat)
                     pat)
                 '*)]
            [(pair? pat)
             (if (and (pair? (cdr pat))
                      (eq? (cadr pat) '...)
                      (null? (cddr pat)))
                 `(,(match-pattern keys (car pat)) ...)
                 (cons (match-pattern keys (car pat))
                       (match-pattern keys (cdr pat))))]
            [else pat])))

   (define make-quasi
      (lambda (exp)
         (if (and (pair? exp) (eq? (car exp) 'unquote))
             (cadr exp)
             (list 'quasiquote exp))))

   (define make-clause
      (lambda (keys cl x)
         (cond
            [(syntax-match? '(* * *) cl)
             (let ([pat (car cl)] [fender (cadr cl)] [exp (caddr cl)])
                (checkpat keys pat pat)
                (let ([ids (parse keys pat x '() '())])
                   `((and (syntax-match? ',(match-pattern keys pat) ,x)
                          ,(gen-quotes keys fender ids '()))
                     ,(make-quasi (gen keys exp ids '() 0)))))]
            [(syntax-match? '(* *) cl)
             (let ([pat (car cl)] [exp (cadr cl)])
                (checkpat keys pat pat)
                (let ([ids (parse keys pat x '() '())])
                   `((syntax-match? ',(match-pattern keys pat) ,x)
                     ,(make-quasi (gen keys exp ids '() 0)))))]
            [else
             (error 'extend-syntax "invalid clause ~s" cl)])))

   (define make-syntax
      (let ([x (string->uninterned-symbol "x")]
            [e (string->uninterned-symbol "e")])
         (lambda (keys clauses)
            (when (memq '... keys)
               (error 'extend-syntax
                       "invalid keyword ... in keyword list ~s"
                       keys))
            `(lambda (,x ,e)
                (unless (procedure? ,e)
                   (error ',(car keys) "~s is not a procedure" ,e))
                (,e (cond
                       ,@(map (lambda (cl) (make-clause keys cl x)) clauses)
                       (else
                        (error ',(car keys) "invalid syntax ~s" ,x)))
                    ,e)))))

   (extend-syntax (extend-syntax)
      [(extend-syntax (key1 key2 ...) clause ...)
       (andmap symbol? '(key1 key2 ...))
       (with ([proc (make-syntax '(key1 key2 ...) '(clause ...))])
          (define-syntax-expander key1 proc))])

   (extend-syntax (extend-syntax/code)
      [(extend-syntax/code (key1 key2 ...) clause ...)
       (andmap symbol? '(key1 key2 ...))
       (with ([proc (make-syntax '(key1 key2 ...) '(clause ...))])
          'proc)]))

(define syntax-match?
   (lambda (pat exp)
      (or (eq? pat '*)
          (eq? exp pat)
          (and (pair? pat)
               (cond
                  [(and (eq? (car pat) '\\)
                        (pair? (cdr pat))
                        (null? (cddr pat)))
                   (eq? exp (cadr pat))]
                  [(and (pair? (cdr pat))
                        (eq? (cadr pat) '...)
                        (null? (cddr pat)))
                   (let ([pat (car pat)])
                      (let f ([lst exp])
                         (or (null? lst)
                             (and (pair? lst)
                                  (syntax-match? pat (car lst))
                                  (f (cdr lst))))))]
                  [else
                   (and (pair? exp)
                        (syntax-match? (car pat) (car exp))
                        (syntax-match? (cdr pat) (cdr exp)))])))))
