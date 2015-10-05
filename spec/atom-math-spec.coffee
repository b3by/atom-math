AtomMath = require '../lib/atom-math'

describe "AtomMath", ->
  [workspaceElement, activationPromise] = []
  testEditor = null

  triggerEvaluation = (callback) ->
    atom.commands.dispatch(workspaceElement, 'atom-math:evaluate')
    waitsForPromise -> activationPromise
    runs(callback)

  beforeEach ->
    workspaceElement = atom.views.getView atom.workspace
    activationPromise = atom.packages.activatePackage 'atom-math'
    waitsForPromise ->
      atom.workspace.open('./myTest').then (editor) ->
        testEditor = editor

  describe 'When the plugin is executed', ->

    it 'should add a new line to the buffer', ->
      expect(testEditor.getLineCount()).toBe 1
      testEditor.insertText 'some content'
      triggerEvaluation ->
        expect(testEditor.getLineCount()).toBe 3

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
