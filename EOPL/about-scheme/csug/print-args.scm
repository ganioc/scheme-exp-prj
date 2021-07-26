#!/usr/local/Cellar/chezscheme/9.5.4_1/bin/chez --script

(for-each
 (lambda (x)
   (display x)
   (newline))
 (cdr (command-line)))

