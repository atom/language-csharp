describe "Language C# package", ->
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-csharp")

  describe "C# grammar", ->
    it "parses the grammar", ->
      grammar = atom.grammars.grammarForScopeName("source.cs")
      expect(grammar).toBeDefined()
      expect(grammar.scopeName).toBe "source.cs"

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
