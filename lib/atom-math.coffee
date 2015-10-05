{allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'
Mathjs = allowUnsafeEval ->
  allowUnsafeNewFunction -> require 'mathjs'

module.exports = AtomMath =

  activate: (state) ->
    atom.commands.add 'atom-workspace', 'atom-math:evaluate': (event) => @evaluate event

  initialize: (serializeState) ->

  evaluate: ->
    if editor = atom.workspace.getActiveTextEditor()

      # getting the last line in the buffer
      currentRow = editor.getCursorBufferPosition().row
      if editor.lineTextForBufferRow(currentRow) is 0
        return

      # getting the expression to evaluate
      toEvaluate = editor.lineTextForBufferRow currentRow

      try
        result = allowUnsafeEval -> allowUnsafeNewFunction -> Mathjs.eval toEvaluate
      catch error
        result = 'wrong syntax'

      editor.moveToEndOfLine()
      editor.insertNewline()
      editor.insertText '> ' + result
      editor.insertNewline()

  deactivate: ->
    atom.commands.add 'atom-workspace', 'atom-math:evaluate': (event) => @evaluate event
