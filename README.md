# atom-math package

Atom package for evaluating mathematical expressions using `Math.js` as interpreter.

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

Command history can be navigated by using `ctrl-up` and `ctrl-down`. Browsing
the command history implies that the current line is emptied and replaced either
with a command when any is available in that direction, or with an empty line.
