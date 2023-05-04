//
//  Property.swift
//

import Foundation
import ReactiveSwift

extension PropertyProtocol where Value: Equatable {
    
    /// Maps the Property to a `Bool`. If the current value is equal to the
    /// passed in value, it will be true, otherwise it's false
    /// - parameter value: A value with the same type as the Property
    /// - returns a `Property<Bool>` indicating whether the current value equals the supplied value
    public func `is`(_ value: Value) -> Property<Bool> {
        self.map { $0 == value }
    }
}

extension Property {
    
    /// Syntactic sugar for creating a Property with a static value
    public static func constant(_ value: Value) -> Property<Value> {
        Property<Value>(value: value)
    }
}

extension PropertyProtocol where Value == Bool {
    public func mapIf<T>(on: T, off: T) -> Property<T> {
        .init(
            initial: self.value ? on : off,
            then: self.producer.mapIf(on: on, off: off)
        )
    }
}

#if os(iOS)
import UIKit
extension Property {

    /// A property that wraps new values from the property in an animation block
    public func animated(duration: TimeInterval) -> Property<Value> {
        .init(
            initial: self.value,
            then: self.producer.animated(duration: duration)
        )
    }
}
#endif

