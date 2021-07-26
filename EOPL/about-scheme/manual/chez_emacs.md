# Chez with Emacs

```scheme
(library-directories)
(("." . "."))

(library-extensions)
((".chezscheme.sls" . ".chezscheme.so")
  (".ss" . ".so")
  (".sls" . ".so")
  (".scm" . ".so")
  (".sch" . ".so"))



```

更新 zshrc

```shell
export CHEZSCHEMELIBDIRS="/Users/username/scheme/lib:"
export CHEZSCHEMELIBEXTS=".sc::.so:"
```

import 库

```scheme
(import (srfi s1 lists))
```

**包管理:**
Akku, 支持 的方言有：

```
Chez Scheme✻
Chibi Scheme‡
GNU Guile✻
Gauche Scheme‡
Ikarus Scheme
IronScheme
Larceny Scheme
Loko Scheme
Mosh Scheme
Racket (plt-r6rs)
Sagittarius Scheme
Vicare Scheme
Ypsilon Scheme

## 下载安装 需要guile

akku list
akku install



```

**Geiser**
Geiser 可以使 Emacs 可以运行多个 Scheme 实现

To customize Geiser, I used the menu options rather than directly editing the .emacs file. Choose Options/Customize Emacs/Specific Group... and type geiser at the prompt. Click on Geiser Chez

~/.chez-geiser

M-x followed by run-chez, 成功. chez

```
Chez Scheme Version 9.5.4
```

(add-to-list 'auto-mode-alist
'("\\.sls\\'" . scheme-mode)
'("\\.sc\\'" . scheme-mode))

## How to set geiser REPL for the buffer?

C-c C-s chez, // switch

# CSUG 9

Chez Scheme User Guide

## Chap 1

object (datum) level

syntactic forms

\

| , group of characters,

(gensym), pretty, unique names,

#vfx()

#3(a b c)

#&17, ;; box , containing the integer 17

#!eof ;; end of file object

#!r6rs

#!r5rs

--script

--program ;; as top-level program,

--libdirs, ;;

--libexts, ;; addtional extensions to search

libraries used entirely within:

- other libraries
- RNRS top-level programs

load

load-library

import a file

```scheme
library-directories

library-extensions

compile-file - to *.so
compile-program
compile-library

#!chezscheme
load-program
load-library
#!r6rs

#!/usr/bin/scheme --script
(for-each
  (lambda (x) (display x) (newline))
  (cdr (command-line)))


compile-whole-program

```

shell

```shell
scheme --libdirs "home/moi/lib:"

echo '(compile-program "filename")' | chez -q --optimize-level 3


kernel
base boot file

echo '(compile-library "filename")' | scheme -q
chez --script main.ss
echo '(compile-program "filename")' | chez

petite --program ./main.so # 可以直接运行


```

boot file?

**How to Compile Scheme Programs?**

```scheme
;;; hello.ss
(define (hello)
  (printf "hello world~n"))

;;; compile
(make-boot-file "hello.boot" '("chez") "hello.ss")

;;; or
(compile-file "hello.ss")
(make-boot-file "hello.boot" '("petite") "hello.so")

;;; $ scheme -b ./hello.boot
;;; But it is not a compiled program.


(tools sorting) ;; tools is directory, sorting is file
(library-directories)
(("/Users/yango3/scheme/lib" . "/Users/yango3/scheme/lib")
  ("." . "."))
(library-extensions)
((".sc" . ".so") (".chezscheme.sls" . ".chezscheme.so") (".ss" . ".so")
  (".sls" . ".so") (".scm" . ".so") (".sch" . ".so"))


(load)
(load-program) ;; load self containing

;;; Petitie is used as a runtime for compiled Chez application.
petite --program ./main.so
chez --program ./main.so

;;; Building and running
(compile-whole-program)

Boot files are loaded during the process of building the initial heap.

(make-boot-file)


```

The "JIT" part is just an AOT compile at runtime, without most of the nice things that we generally consider being a JIT. SBCL does the same.

> In computing, just-in-time (JIT) compilation, also known as dynamic translation, is a way of executing computer code that involves compilation during execution of a program – at run time – rather than prior to execution. Most often, this consists of source code or more commonly bytecode translation to machine code, which is then executed directly.

Chez Scheme does compile at the REPL, but in general I would not call it a JIT compiler. It just compiles everything the same way regardless of if you are compiling it ahead of time or while you are running in an interactive session.

**Hierarchical Build**

```scheme
(compile-imported-libraries #t)
(generate-wpo-files #t)
(compile-program "./main.ss")
;; (compile-file "./your-program.ss")
(compile-whole-program "./main.wpo" "./main.so")
;; 文件里包含 (import (chezscheme)) 即可，printf undefined error



```

**How to Debug Scheme Programs?**

## Chap 2

## Chap 3
