# Mapping Methods

## Overview 

Unlike with `Result`, the standard library supports [`Optional` mapping](https://developer.apple.com/documentation/swift/optional#Transforming-an-Optional-Value) to an adequate level. No additional code is required by this package.

But, it is useful to understand how the mapping possibilities for `Optional` differ from `Result`, as documented in [HemiprocneMystaceaResult](https://catterwaul.github.io/HemiprocneMystaceaResult/documentation/hmresult/mapping-methods).

### flatMap

Unlike with `Result`, [`Optional.flatMap`](https://developer.apple.com/documentation/swift/optional/flatmap(_:)) is implemented perfectly in the standard library.

[Optional chaining](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/optionalchaining/) represents a specific subset of `flatMap`—the most common use case. It would be great if other "[throwing property wrappers](https://github.com/Catterwaul/Thrappture)" could use chaining as well, but is of course not supported.
 
```swift
let animals: Optional = "🦁🐯🐻"
var first: Character? = animals.flatMap(\.first)
first = animals?.first // Same as above.
```

### flatMapAndMergeError

In [Thrappture](https://github.com/Catterwaul/Thrappture), we've defined `Optional`'s `Failure` type as [`Nil`](<doc:Swift/Optional/Nil>). But regardless of how you model it, 
`Optional.none` is generic over `Optional` itself. That means that the only way for two `Optional` types to "share their failure type", is for the `Optional`s to actually be of the exact same type.

So, `flatMapAndMergeError` would be simplifiable to the following. We haven't felt a need to include this in this package, but are open to doing so if you could convince us of its usefulness.

```swift
func flatMapAndMergeError(
  _ transform: (Wrapped) throws(Nil) -> Self
) -> Self {
  try? transform(get())
}
```

### map

Again, unlike with `Result`, [`Optional.map`](https://developer.apple.com/documentation/swift/optional/map(_:)) is implemented perfectly in the standard library.

### mapAndMergeError

Because Swift allows for values to be implicitly promoted to optionals, the body of `Optional.mapAndMergeError` would be exactly the same as `Optional.flatMapAndMergeError`'s', above. So we're not including this method either.

#### flatMapFailure

`Optional` cannot make use of this by itself, because its `Failure` type always matches its `Wrapped` type. I.e. transforming one `Optional.Nil` to another is the same as transforming one `Optional` to another. That requires a `flatMap`. And, a transformation of `nil`, if you want to do anything other than change one `nil` into `another`.

You can't do much meaningful using `nil` as an input, but there is syntactical sugar available to "transform it"—the [nil-coalescing operator](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/basicoperators/#Nil-Coalescing-Operator). 

A combination of `flatMap`, nil-coalescing, and implicit promotion to optionals is not only about the closest you can get to `flatMapError` with an `Optional`—it's also a practical usage of the "general transformation" methods that start off [the Result mapping article](https://catterwaul.github.io/HemiprocneMystaceaResult/documentation/hmresult/mapping-methods)—just with a different spelling.  

```swift
let characters: Optional = "🦁🐯🐻"
let character: Character? = characters.flatMap { "\($0)👧🏻👠🐒🪽".randomElement() } ?? "🧙‍♀️"
```

#### mapFailureToSuccess

This is nil-coalescing, specifically when the result is non-optional.

***Important to note:*** while nil-coalescing allows for completely removing `Optional` wrappers, you'll sometimes need to use `flatMap`, instead of `map`, to flatten optionality down to one level of wrapping, first. 

```swift
let characters: Optional = "🦁🐯🐻👧🏻👠🐒🪽"
characters?.randomElement() ?? "🧙‍♀️"               // Character
characters.flatMap { $0.randomElement() } ?? "🧙‍♀️" // Character
characters.map { $0.randomElement() } ?? "🧙‍♀️"     // Character?
```

#### mapFailureToSuccessAndErrorToFailure

This is nil-coalescing, when the argument on the right of the `??` is also optional.  

Because `Success` can't change, and `Failure` is tied to `Success`, for `Optional`, `Failure` can't change either.

```swift
let characters: Optional = "🦁🐯🐻👧🏻👠🐒🪽"
let character: Character? = "🧙‍♀️"
characters?.randomElement() ?? character  // Character?
```
