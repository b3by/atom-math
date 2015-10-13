{allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'
Parser = allowUnsafeEval ->
  allowUnsafeNewFunction -> require('mathjs').parser()

module.exports = AtomMath =

  history:       null
  historyIndex:  0

  activate: (state) ->
    @history = []
    atom.commands.add 'atom-workspace', 'atom-math:evaluate': (event) => @evaluate event
    atom.commands.add 'atom-text-editor', 'atom-math:getPreviousHistoryCommand': (event) => @getPreviousHistoryCommand()
    atom.commands.add 'atom-text-editor', 'atom-math:getNextHistoryCommand': (event) => @getNextHistoryCommand()

  initialize: (serializeState) ->

  getPreviousHistoryCommand: ->
    @navigateHistory true

  getNextHistoryCommand: ->
    @navigateHistory false

  navigateHistory: (directionUp) ->
    if !@history or @history.length is 0
      return

    editor = atom.workspace.getActiveTextEditor()

    unless editor
      return

    commandToPrint = ''

    if directionUp and @historyIndex >= 0
      commandToPrint = @history[@historyIndex]
      @historyIndex -= 1
    else if !directionUp and @historyIndex + 1 < @history.length
      @historyIndex += 1
      if @historyIndex + 1 <= @history.length
        commandToPrint = @history[@historyIndex + 1] or ''

    if commandToPrint or !directionUp
      editor.deleteLine()
      editor.insertNewline()
      editor.insertText commandToPrint

  evaluate: ->
    if editor = atom.workspace.getActiveTextEditor()
      currentRow = editor.getCursorBufferPosition().row
      if editor.lineTextForBufferRow(currentRow) is 0
        return

      toEvaluate = editor.lineTextForBufferRow currentRow
      @history.push toEvaluate
      @historyIndex = @history.length - 1

      try
        result = allowUnsafeEval -> allowUnsafeNewFunction -> Parser.eval toEvaluate
        if typeof result is 'function'
          result = 'saved'

      catch error
        result = 'wrong syntax'

      editor.moveToEndOfLine()
      editor.insertNewline()
      editor.insertText "> #{result}"
      editor.insertNewline()

  deactivate: ->
    @history.length = 0
    @historyIndex   = 0
