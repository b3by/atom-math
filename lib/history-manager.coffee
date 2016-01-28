module.exports =
class HistoryManager

  managerInstance = null

  class PrivateHistoryManager

    constructor: () ->
      @history      = []
      @historyIndex = 0

    addCommand: (command) ->
      @history.push command
      @historyIndex = @history.length - 1

    getPreviousHistoryCommand: ->
      @navigateHistory true

    getNextHistoryCommand: ->
      @navigateHistory false

    navigateHistory: (directionUp) ->
      if !@history or @history.length is 0
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
        commandToPrint
      else
        return null

    getHistory: ->
      @history

    ereaseHistory: ->
      @history.length = 0
      @historyIndex   = 0

  @getManager: () ->
    managerInstance ?= new PrivateHistoryManager()
