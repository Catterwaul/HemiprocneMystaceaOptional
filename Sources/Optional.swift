import Thrappture

// MARK: - public
public extension Optional {
  /// A type with all values wrapped in an additional layer of `Optional`.
  ///
  /// - Note: `Never` is for namespacing within `Optional`. The actual `Wrapped` doesn't matter.
  typealias Mapped<each _Wrapped> = (repeat (each _Wrapped)?)
  where Wrapped == Never
  
  /// Equate tuples of arbitrary count.
  @inlinable static func == <each _Wrapped: Equatable>(
    _ optional0: Self, _ optional1: Self
  ) -> Bool
  where Wrapped == (repeat each _Wrapped) {
    switch (optional0, optional1) {
    case let (wrapped0?, wrapped1?):
      for elements in repeat (each wrapped0, each wrapped1) {
        guard elements.0 == elements.1 else { return false }
      }
      return true
    case (nil, nil): return true
    default: return false
    }
  }
  
  /// Equate tuples of arbitrary count.
  @inlinable static func != <each _Wrapped: Equatable>(
    _ optional0: Self, _ optional1: Self
  ) -> Bool
  where Wrapped == (repeat each _Wrapped) {
    !(optional0 == optional1)
  }
  
  /// Exchange a tuple of `Optional`s for a single `Optional` whose `Wrapped` is a tuple.
  /// - Returns: `nil` if any tuple element is `nil`.
  @inlinable static func zip<each _Wrapped>(_ optional: (repeat (each _Wrapped)?)) -> Self
  where Wrapped == (repeat each _Wrapped) {
    try? (repeat (each optional).get())
  }

  /// Transform `.some` into `.none`, if a condition fails.
  /// - Parameters:
  ///   - isSome: The condition that will result in `nil`, when evaluated to `false`.
  @inlinable func filter<Error>(_ isSome: (Wrapped) throws(Error) -> Bool) throws(Error) -> Self {
    try flatMap { wrapped throws(Error) in try isSome(wrapped) ? wrapped : nil }
  }
}
