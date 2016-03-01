HistoryManager = require './history-manager'

module.exports =
class CoreCommander

  @commands:
    functionList:
      description: 'Print a list of all defined functions'
      caller: => @functionList()
    clearHistory:
      description: 'Empty the history'
      caller: => @clearHistory()
    clipHistory:
      description: 'Copy history into clipboard'
      caller: => @clipHistory()
    help:
      description: 'Print the full command list'
      caller: => @help()

  clearCommand: (fullCommand) ->
    return fullCommand.split(' ')[0].slice 1

  isCoreCommand: (fullCommand) ->
    command = @clearCommand fullCommand
    if CoreCommander.commands[command] then return true else return false

  runCoreCommand: (fullCommand) ->
    command = @clearCommand fullCommand

    unless CoreCommander.commands[command]
      throw new Error 'Command not recognized'

    CoreCommander.commands[command].caller()

  @getReadableHistory: (functionsOnly) ->
    rawHistory = HistoryManager.getManager().getHistory()
    history = '\n'

    for historyEntry, index in rawHistory
      if functionsOnly
        history += historyEntry + '\n' unless historyEntry.indexOf('=') is -1
      else
        history += historyEntry + '\n'

    history.replace /\n$/, ''

  @functionList: ->
    @getReadableHistory true

  @clearHistory: ->
    HistoryManager.getManager().ereaseHistory()
    return 'history empty'

  @clipHistory: ->
    atom.clipboard.write @getReadableHistory false
    'history copied into clipboard'

  @help: ->
    commandList = 'Full command list below\n'
    for cmdName, cmd of CoreCommander.commands
      commandList += cmdName + ' - ' + cmd.description + '\n'
    commandList.replace /\n$/, ''
