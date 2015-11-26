# atom-math
[![Build Status](https://img.shields.io/travis/b3by/atom-math.svg?style=flat-square)](https://travis-ci.org/b3by/atom-math)
[![Plugin installs!](https://img.shields.io/apm/dm/atom-math.svg?style=flat-square)](https://atom.io/packages/atom-math)
[![Package version!](https://img.shields.io/apm/v/atom-math.svg?style=flat-square)](https://atom.io/packages/atom-math)
[![Dependencies!](https://img.shields.io/david/b3by/atom-math.svg?style=flat-square)](https://david-dm.org/b3by/atom-math)

[atom.io pkg](https://atom.io/packages/atom-math)

Atom package for evaluating mathematical expressions using [Math.js](http://mathjs.org/) as interpreter.

### Simple expressions
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

### Functions
More complex expressions can be evaluated too.

```
f(x) = x^2 + log(x)
> saved
f(3)
> 10.09861228866811
g(x, y) = 2 + y + f(x)
> saved
g(2, 3)
> 9.693147180559945
```

### Command history
Command history can be navigated by using `ctrl-up` and `ctrl-down`. Browsing
the command history implies that the current line is emptied and replaced either
with a command when any is available in that direction, or with an empty line.

### Like what you see?
Please feel free to contribute anyway you feel might be useful. New feature suggestions
or merge requests are more than welcome!
