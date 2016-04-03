{CompositeDisposable} = require 'atom'

module.exports = AtomMath =

  historyManager: null
  coreCommander:  null
  parser:         null
  mathUtils:      null

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

    toEvaluate = editor.lineTextForBufferRow(currentRow).trim()
    @historyManager.addCommand toEvaluate

    if toEvaluate.startsWith('/') and @coreCommander.isCoreCommand toEvaluate
      result = @coreCommander.runCoreCommand toEvaluate
    else
      @mathUtils ?= require './math-utils'
      result = @mathUtils.evaluateExpression toEvaluate

    editor.moveToEndOfLine()
    editor.insertNewline()
    editor.insertText "> #{result}"
    editor.insertNewline()

  deactivate: ->
    @subscriptions.dispose()

    @historyManager = null
    @coreCommander  = null
    @parser         = null
