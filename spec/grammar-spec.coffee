describe "Language C# package", ->

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-csharp")

  describe "C# grammar", ->
    grammar = null

    beforeEach ->
      runs ->
        grammar = atom.grammars.grammarForScopeName('source.cs')

    it "parses the grammar", ->
      expect(grammar).toBeDefined()
      expect(grammar.scopeName).toBe "source.cs"

    it "tokenizes strings in method calls", ->
      tokens = grammar.tokenizeLines """
        class F {
          a = C("1.1 10\\n");
        })
      """

      expect(tokens[1][1]).toEqual value: 'C', scopes: ['source.cs', 'meta.class.source.cs', 'meta.class.body.source.cs', 'meta.method-call.source.cs', 'meta.method.source.cs']
      expect(tokens[1][2]).toEqual value: '(', scopes: ['source.cs', 'meta.class.source.cs', 'meta.class.body.source.cs', 'meta.method-call.source.cs', 'punctuation.definition.method-parameters.begin.source.cs']
      expect(tokens[1][3]).toEqual value: '"', scopes: ['source.cs', 'meta.class.source.cs', 'meta.class.body.source.cs', 'meta.method-call.source.cs', 'string.quoted.double.source.cs', 'punctuation.definition.string.begin.source.cs']
      expect(tokens[1][4]).toEqual value: '1.1 10', scopes: ['source.cs', 'meta.class.source.cs', 'meta.class.body.source.cs', 'meta.method-call.source.cs', 'string.quoted.double.source.cs']
      expect(tokens[1][5]).toEqual value: '\\n', scopes: ['source.cs', 'meta.class.source.cs', 'meta.class.body.source.cs', 'meta.method-call.source.cs', 'string.quoted.double.source.cs', 'constant.character.escape.source.cs']
      expect(tokens[1][6]).toEqual value: '"', scopes: ['source.cs', 'meta.class.source.cs', 'meta.class.body.source.cs', 'meta.method-call.source.cs', 'string.quoted.double.source.cs', 'punctuation.definition.string.end.source.cs']
      expect(tokens[1][7]).toEqual value: ')', scopes: ['source.cs', 'meta.class.source.cs', 'meta.class.body.source.cs', 'meta.method-call.source.cs', 'punctuation.definition.method-parameters.end.source.cs']


  describe "C# Script grammar", ->
    it "parses the grammar", ->
      grammar = atom.grammars.grammarForScopeName("source.csx")
      expect(grammar).toBeDefined()
      expect(grammar.scopeName).toBe "source.csx"

  describe "C# Cake grammar", ->
    it "parses the grammar", ->
      grammar = atom.grammars.grammarForScopeName("source.cake")
      expect(grammar).toBeDefined()
      expect(grammar.scopeName).toBe "source.cake"

  describe "NAnt Build File grammar", ->
    it "parses the grammar", ->
      grammar = atom.grammars.grammarForScopeName("source.nant-build")
      expect(grammar).toBeDefined()
      expect(grammar.scopeName).toBe "source.nant-build"
