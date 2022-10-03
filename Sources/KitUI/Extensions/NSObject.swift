import Foundation
import ReactiveCocoa
import ReactiveSwift

// MARK: Experiment! Use at your own risk!
extension NSObject {
    
    /// A generic, chainable method for piping values into an object at a certain keypath
    /// - parameter keyPath: The keypath on the current object. It's possible to pass in a keypath
    ///   that's incompatible with the current object. In that case this function will be a no-op
    /// - parameter value: A `SignalProducerConvertible` value that will have it's values piped into
    ///   the keypath
    /// - returns: The object it's called on, for chainability
    public func receive<T: SignalProducerConvertible, U: NSObject>(
        _ keyPath: ReferenceWritableKeyPath<U, T.Value>,
        _ value: T
    ) -> Self {
        if let self = self as? U {
            self.reactive[keyPath] <~ value.producer.eraseError()
        }
        return self
    }
}
