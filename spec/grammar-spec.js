describe("Language C# package", () => {
  beforeEach(() =>
    waitsForPromise(() => atom.packages.activatePackage("language-csharp"))
  )

  describe("C# Script grammar", () =>
    it("parses the grammar", () => {
      const grammar = atom.grammars.grammarForScopeName("source.csx")
      expect(grammar).toBeDefined()
      return expect(grammar.scopeName).toBe("source.csx")
    })
  )

  return describe("C# Cake grammar", () =>
    it("parses the grammar", () => {
      const grammar = atom.grammars.grammarForScopeName("source.cake")
      return expect(grammar).toBeDefined()
    })
  )
})

expect(grammar.scopeName).toBe("source.cake")
