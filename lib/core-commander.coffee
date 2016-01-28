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

  @functionList: ->
    history = HistoryManager.getManager().getHistory()
    functionHistory = '\n'

    for historyEntry, index in history
      if historyEntry.indexOf('=') isnt -1
        functionHistory += historyEntry + '\n'

    functionHistory.replace /\n$/, ''

  @clearHistory: ->
    HistoryManager.getManager().ereaseHistory()
    return 'history empty'
