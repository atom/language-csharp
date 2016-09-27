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

    it "tokenizes variable type followed by comment", ->
      tokens = grammar.tokenizeLines """
      struct hi {
        byte q; //(
      }
      """

      expect(tokens[1][1]).toEqual value: 'byte ', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'storage.value.type.cs']
      expect(tokens[1][3]).toEqual value: '//', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'comment.line.double-slash.cs']
      expect(tokens[1][4]).toEqual value: '(', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'comment.line.double-slash.cs']

      tokens = grammar.tokenizeLines """
      struct hi {
        byte q; /*(*/
      }
      """
      expect(tokens[1][1]).toEqual value: 'byte ', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'storage.value.type.cs']
      expect(tokens[1][3]).toEqual value: '/*', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'comment.block.cs', 'punctuation.definition.comment.cs']
      expect(tokens[1][4]).toEqual value: '(', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'comment.block.cs']

    it "tokenizes method definitions correctly", ->
      {tokens} = grammar.tokenizeLine("void func()")
      expect(tokens[0]).toEqual value: 'void ', scopes: ['source.cs', 'storage.type.cs']
      expect(tokens[1]).toEqual value: 'func', scopes: ['source.cs', 'meta.method-call.cs', 'meta.method.cs']
      expect(tokens[2]).toEqual value: '(', scopes: ['source.cs', 'meta.method-call.cs', 'punctuation.definition.method-parameters.begin.cs']

      {tokens} = grammar.tokenizeLine("dictionary<int, string> func()")
      expect(tokens[1]).toEqual value: 'func', scopes: ['source.cs', 'meta.method-call.cs', 'meta.method.cs']
      expect(tokens[2]).toEqual value: '(', scopes: ['source.cs', 'meta.method-call.cs', 'punctuation.definition.method-parameters.begin.cs']

      {tokens} = grammar.tokenizeLine("void func(test = default_value)")
      expect(tokens[0]).toEqual value: 'void ', scopes: ['source.cs', 'storage.type.cs']
      expect(tokens[1]).toEqual value: 'func', scopes: ['source.cs', 'meta.method-call.cs', 'meta.method.cs']
      expect(tokens[2]).toEqual value: '(', scopes: ['source.cs', 'meta.method-call.cs', 'punctuation.definition.method-parameters.begin.cs']

    it "tokenizes method calls", ->
      {tokens} = grammar.tokenizeLine("a = func(1)")
      expect(tokens[3]).toEqual value: 'func', scopes: ['source.cs', 'meta.method-call.cs', 'meta.method.cs']
      expect(tokens[4]).toEqual value: '(', scopes: ['source.cs', 'meta.method-call.cs', 'punctuation.definition.method-parameters.begin.cs']

      {tokens} = grammar.tokenizeLine("func()")
      expect(tokens[0]).toEqual value: 'func', scopes: ['source.cs', 'meta.method-call.cs', 'meta.method.cs']
      expect(tokens[1]).toEqual value: '(', scopes: ['source.cs', 'meta.method-call.cs', 'punctuation.definition.method-parameters.begin.cs']

      {tokens} = grammar.tokenizeLine("func  ()")
      expect(tokens[0]).toEqual value: 'func', scopes: ['source.cs', 'meta.method-call.cs', 'meta.method.cs']
      expect(tokens[2]).toEqual value: '(', scopes: ['source.cs', 'meta.method-call.cs', 'punctuation.definition.method-parameters.begin.cs']

      {tokens} = grammar.tokenizeLine("func ()")
      expect(tokens[0]).toEqual value: 'func', scopes: ['source.cs', 'meta.method-call.cs', 'meta.method.cs']
      expect(tokens[2]).toEqual value: '(', scopes: ['source.cs', 'meta.method-call.cs', 'punctuation.definition.method-parameters.begin.cs']

    it "tokenizes strings in method calls", ->
      tokens = grammar.tokenizeLines """
        class F {
          a = C("1.1 10\\n");
        })
      """

      expect(tokens[1][3]).toEqual value: 'C', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'meta.method-call.cs', 'meta.method.cs']
      expect(tokens[1][4]).toEqual value: '(', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'meta.method-call.cs', 'punctuation.definition.method-parameters.begin.cs']
      expect(tokens[1][5]).toEqual value: '"', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'meta.method-call.cs', 'string.quoted.double.cs', 'punctuation.definition.string.begin.cs']
      expect(tokens[1][6]).toEqual value: '1.1 10', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'meta.method-call.cs', 'string.quoted.double.cs']
      expect(tokens[1][7]).toEqual value: '\\n', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'meta.method-call.cs', 'string.quoted.double.cs', 'constant.character.escape.cs']
      expect(tokens[1][8]).toEqual value: '"', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'meta.method-call.cs', 'string.quoted.double.cs', 'punctuation.definition.string.end.cs']
      expect(tokens[1][9]).toEqual value: ')', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'meta.method-call.cs', 'punctuation.definition.method-parameters.end.cs']

    it "tokenizes strings in classes", ->
      tokens = grammar.tokenizeLines """
        class a
        {
          b = c + "(";
        }
      """

      expect(tokens[2][5]).toEqual value: '"', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'string.quoted.double.cs', 'punctuation.definition.string.begin.cs']
      expect(tokens[2][6]).toEqual value: '(', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'string.quoted.double.cs']
      expect(tokens[2][7]).toEqual value: '"', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'string.quoted.double.cs', 'punctuation.definition.string.end.cs']
      expect(tokens[2][8]).toEqual value: ';', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs']

      tokens = grammar.tokenizeLines """
        class a
        {
          b([c(d = "Command e")] string f)
          {
          }
        }
      """

      expect(tokens[2][9]).toEqual value: '"', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'meta.method-call.cs', 'meta.method-call.cs', 'string.quoted.double.cs', 'punctuation.definition.string.begin.cs']
      expect(tokens[2][10]).toEqual value: 'Command e', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'meta.method-call.cs', 'meta.method-call.cs', 'string.quoted.double.cs']
      expect(tokens[2][11]).toEqual value: '"', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'meta.method-call.cs', 'meta.method-call.cs', 'string.quoted.double.cs', 'punctuation.definition.string.end.cs']
      expect(tokens[2][14]).toEqual value: 'string ', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'meta.method-call.cs', 'storage.reference.type.cs']
      expect(tokens[2][15]).toEqual value: 'f', scopes: ['source.cs', 'meta.class.cs', 'meta.class.body.cs', 'meta.method-call.cs']

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
