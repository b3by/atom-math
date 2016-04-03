{allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'

module.exports = MathUtils =

  integrator: null
  parser:     null

  evaluateExpression: (rawExpression) ->
    if rawExpression.startsWith 'integrate('
      return @integrate rawExpression

    @setParser()
    
    try
      result = allowUnsafeEval => allowUnsafeNewFunction =>
        @parser.eval rawExpression

      if typeof result is 'function'
        result = 'saved'

    catch error
      result = 'wrong syntax'

    result

  integrate: (rawExpression) ->
    splittedExpression = rawExpression.split('integrate(')[1]
    functionName = splittedExpression.split(',')[0].trim()
    startPoint   = parseInt splittedExpression.split(',')[1].trim()
    endPoint     = parseInt splittedExpression.split(',')[2].trim()
    pace         = parseInt splittedExpression.split(',')[3].split(')')[0].trim()

    @setParser()

    concreteFunction = allowUnsafeEval => allowUnsafeNewFunction =>
      @parser.get functionName

    @integrator ?= require 'integrate-adaptive-simpson'
    @integrator concreteFunction, startPoint, endPoint, pace

  setParser: ->
    @parser ?= allowUnsafeEval ->
      allowUnsafeNewFunction -> require('mathjs').parser()
