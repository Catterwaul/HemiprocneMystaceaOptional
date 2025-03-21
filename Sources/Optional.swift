import Thrappture

// MARK: - public
public extension Optional {
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
