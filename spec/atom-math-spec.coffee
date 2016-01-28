AtomMath = require '../lib/atom-math'

describe 'AtomMath', ->
  [workspaceElement, activationPromise] = []
  testEditor = null

  triggerEvaluation = (callback) ->
    atom.commands.dispatch workspaceElement, 'atom-math:evaluate'
    waitsForPromise -> activationPromise
    runs callback

  beforeEach ->
    workspaceElement = atom.views.getView atom.workspace
    activationPromise = atom.packages.activatePackage 'atom-math'
    waitsForPromise ->
      atom.workspace.open('./myTest').then (editor) =>
        testEditor = editor

  describe 'When the plugin is executed', ->

    it 'should add a new line to the buffer', ->
      expect(testEditor.getLineCount()).toBe 1
      testEditor.insertText 'some context'
      triggerEvaluation -> expect(testEditor.getLineCount()).toBe 3

    it 'should evaluate basic expressions', ->
      testEditor.insertText '1 + 2'
      triggerEvaluation ->
        expect(testEditor.lineTextForBufferRow(1)).toBe '> 3'

    it 'should evaluate basic symbols', ->
      testEditor.insertText 'cos(pi)'
      triggerEvaluation ->
        expect(testEditor.lineTextForBufferRow(1)).toBe '> -1'

      testEditor.insertText 'phi'
      triggerEvaluation ->
        expect(testEditor.lineTextForBufferRow(3)).toBe '> 1.618033988749895'

    it 'should detect bad syntax when provided', ->
      testEditor.insertText 'faulty syntaxt'
      triggerEvaluation ->
        expect(testEditor.lineTextForBufferRow(1)).toBe '> wrong syntax'

    it 'should fetch the previous and next commands in the history', ->
      testEditor.insertText '1 + 2'
      triggerEvaluation ->
        pkg = atom.packages.getActivePackage 'atom-math'
        pkg.mainModule.getPreviousHistoryCommand()
        expect(testEditor.lineTextForBufferRow(2)).toBe '1 + 2'
        pkg.mainModule.getNextHistoryCommand()
        expect(testEditor.lineTextForBufferRow(2)).toBe ''
        testEditor.insertText '3 + 4'
        triggerEvaluation ->
          pkg.mainModule.getPreviousHistoryCommand()
          expect(testEditor.lineTextForBufferRow(4)).toBe '3 + 4'
          pkg.mainModule.getPreviousHistoryCommand()
          expect(testEditor.lineTextForBufferRow(4)).toBe '1 + 2'

    it 'should store custom functions and properly evaluate them', ->
      testEditor.insertText 'f(x) = 3 + x * 2'
      triggerEvaluation ->
        expect(true).toBe true
        expect(testEditor.lineTextForBufferRow(1)).toBe '> saved'
        testEditor.insertText 'f(2)'
        triggerEvaluation ->
          expect(testEditor.lineTextForBufferRow(3)).toBe '> 7'

    it 'should evaluate more complex functions', ->
      testEditor.insertText 'f(x) = x + 2'
      triggerEvaluation ->
        testEditor.insertText 'g(x, y) = 2 + y + f(x)'
        triggerEvaluation ->
          testEditor.insertText 'g(2, 3)'
          triggerEvaluation ->
            expect(testEditor.lineTextForBufferRow(5)).toBe '> 9'

    it 'should print the function list', ->
      testEditor.insertText 'f(x) = x + 2'
      triggerEvaluation ->
        testEditor.insertText '/functionList'
        triggerEvaluation ->
          expect(testEditor.lineTextForBufferRow 7).toBe 'f(x) = x + 2'

    it 'should clean the history', ->
      testEditor.insertText '/clearHistory'
      triggerEvaluation ->
        expect(testEditor.lineTextForBufferRow 1).toBe '> history empty'
        pkg = atom.packages.getActivePackage 'atom-math'
        pkg.mainModule.getPreviousHistoryCommand()
        expect(testEditor.lineTextForBufferRow 2).toBe ''
