## 0.0.9
* **Experimental**: new function definite integration
> Definite integration may be executed in `atom-math` with the usage of
> [this awesome](https://github.com/scijs/integrate-adaptive-simpson)
> package from [scijs](https://github.com/scijs). This feature is still
> unstable, so it does not behave as expected when provided evaluation
> points are floating point. Please refer to [this issue](https://github.com/scijs/integrate-adaptive-simpson/issues/1) to get some examples of how the malfunction can manifest.
* :art: General code refactoring

## 0.0.8
* :bug: Core commands are now evaluated also with head whitespaces
* :white_check_mark: New test case added for core commands evaluation

## 0.0.7
* :arrow_up: `mathjs` version updated

## 0.0.6
* :racehorse: Modules are lazily imported, so loading and activation times are significantly reduced
* New core commands: `clipHistory` to copy history into clipboard, `help` to print the full command list with description
* General code refactoring and improvement

## 0.0.5 - Core commands capability
* New feature for adding inner commands
* `functionList` and `clearHistory` commands added
* Code restyles
* Minor bug fixes

## 0.0.4 - Commands added to disposables
* Commands are now added to disposables, so they're disposed when the package is
deactivated
* CI added to the project
* Code minor restyles

## 0.0.3 - Function evaluation
* Functions evaluation added
* Activation command removed (package is now automatically activated)

## 0.0.2 - History available
* Command history added
* General code refactoring

## 0.0.1 - First Release
* Simple expression evaluation included
* Wrong syntax alert included
