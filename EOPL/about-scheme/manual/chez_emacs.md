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
