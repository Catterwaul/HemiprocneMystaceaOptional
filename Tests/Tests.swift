import HMOptional
import Testing
import Thrappture

struct OptionalTests {
  @Test func `== operator`() throws {
    let values = (1, 2.0, "3")
    var optional: Optional = values
    #expect(optional == values)
    
    optional?.1 = 0
    #expect(optional != values)
    
    optional = nil
    #expect(optional == optional)
    #expect(optional != values)
  }
  
  @Test func `Mapped`() {
    let values = (1, 2.0, "3")
    #expect(type(of: values as _?.Mapped) == (Int?, Double?, String?).self)
  }

  @Test func zip() throws {
    let jenies = ("👖", "🧞‍♂️")
    #expect(try #require(Optional.zip(jenies)) == jenies)

    // `jenies` should be have been `var`,
    // and this block should not be necessary, but
    // https://github.com/apple/swift/issues/74425
    do {
      var optionalJenies = jenies as _?.Mapped
      optionalJenies.1 = nil
      let jenies = optionalJenies
      #expect(throws: (String, String)?.Nil.self) {
        try _?.zip(jenies).get()
      }
    }
  }
    
  @Test func filter() throws {
    let optional: Optional = 1
    #expect(optional.filter { $0 > 0 } == 1)
    #expect(optional.filter { $0 > 1 } == nil)
  }
}
