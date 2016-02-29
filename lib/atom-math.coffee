{allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'
{CompositeDisposable}                     = require 'atom'

module.exports = AtomMath =

  historyManager: null
  coreCommander:  null
  parser:         null

  activate: (state) ->
    HistoryManager = require './history-manager'
    @historyManager = HistoryManager.getManager()

    CoreCommander  = require './core-commander'
    @coreCommander = new CoreCommander()

    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
      'atom-math:evaluate': (event) =>
        @evaluate event

    @subscriptions.add atom.commands.add 'atom-text-editor',
      'atom-math:getPreviousHistoryCommand': (event) =>
        @getPreviousHistoryCommand()

    @subscriptions.add atom.commands.add 'atom-text-editor',
      'atom-math:getNextHistoryCommand': (event) =>
        @getNextHistoryCommand()

  initialize: (serializeState) ->

  getPreviousHistoryCommand: ->
    @printOnBuffer @historyManager.getPreviousHistoryCommand()

  getNextHistoryCommand: ->
    @printOnBuffer @historyManager.getNextHistoryCommand()

  printOnBuffer: (toPrint) ->
    editor = atom.workspace.getActiveTextEditor()
    unless editor
      return

    if toPrint?
      editor.moveToBeginningOfLine()
      editor.selectToEndOfLine()
      editor.insertText toPrint

  evaluate: ->
    editor = atom.workspace.getActiveTextEditor()
    unless editor
      return

    currentRow = editor.getCursorBufferPosition().row
    if editor.lineTextForBufferRow(currentRow) is 0
      return

    toEvaluate = editor.lineTextForBufferRow currentRow
    @historyManager.addCommand toEvaluate

    if toEvaluate.startsWith('/') and @coreCommander.isCoreCommand toEvaluate
      result = @coreCommander.runCoreCommand toEvaluate
    else
      @parser ?= allowUnsafeEval ->
        allowUnsafeNewFunction -> require('mathjs').parser()
      try
        result = allowUnsafeEval => allowUnsafeNewFunction =>
          @parser.eval toEvaluate

        if typeof result is 'function'
          result = 'saved'

      catch error
        result = 'wrong syntax'

    editor.moveToEndOfLine()
    editor.insertNewline()
    editor.insertText "> #{result}"
    editor.insertNewline()

  deactivate: ->
    @subscriptions.dispose()
    @history.length = 0
    @historyIndex   = 0

    @historyManager = null
    @coreCommander  = null
    @parser         = null
