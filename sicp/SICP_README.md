## chap1 The Elements of Programming

- primitive expression
- means of combination
- means of abstraction

## chap3 define abstraction with data

page 94,

## signal-flow plans

信号流图,

as modular, modular structure, Modular construction,

## patterns of combining

frame - origin vector - edge 1 vector - edge 2 vector

Shift and scale images to fit the frame. 将 unit square 转换为一个 frame mapping the vector v=(x,y) to the vector sum:

## 2.3 Symbolic Data

Using arbitrary symbols as data,

eq?
memq?

symbolic differentiation, 字符微分, powerful systems for symbolic mathematical work, applied mathematicians and physicists.

### Representing Sets

表示集合, set,

- unordered list,
- ordered lists, 这个会加快搜索速度,

### Sets as binary trees

Balanced tree.

(quotient) 求商,

**generic procedures**
procedure 可以处理多种类型的数据的，
用一个函数，命令处理所有的类型数据，包括已知数据类型，也包括未知的将来的数据类型，这个就是模版，所要求解决的问题。

给出一个字母表的符号，和它们的相对出现频率，construct the best code.
With the fewest bits?

> (decode sample-message sample-tree)

    (A D A B B C A)

> (encode '(A D A) sample-tree)

    (0 1 1 0 0)

需要编写 Successive-merge 来生成 huffman-tree, not that complicated.
输入的 pair 是'((A 4) (B 2) (C 1) (D 1))

> (make-leaf-set sample-pairs)
> ((leaf D 1) (leaf C 1) (leaf B 2) (leaf A 4))

如何来写呢？

```scheme
(make-code-tree (make-leaf 'A 4)
    (make-code-tree (make-leaf 'B 2)
        (make-code-tree
            (make-leaf 'D 1)
            (make-leaf 'C 1))))
```
完成了!

## 2.4 Multiple Representations for Abstract Data




