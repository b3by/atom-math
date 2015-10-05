# atom-math package

Atom package for evaluating mathematical expression using `Math.js` as interpreter.

When working with a buffer, just write an expression to be evaluated like `3 + 2`
or `cos(pi)`, then press the default hotkey `ctrl-alt-m` and the output will be
inserted in a new line.

A generic call to the package will be like:

```
1 + 3
> 4
cos(pi)
> -1
log(0)
> -Infinity
can I plz has math
> wrong syntax
```
