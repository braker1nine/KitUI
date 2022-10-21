//
//  Signal.swift
//  

import Foundation
import ReactiveSwift

extension Signal {
    
    /// Convert a signal into a signal with a `Void` value
    public var void: Signal<(), Error> {
        self.map { _ in () }
    }
    
    /// Map all values from signal to a specific value
    public func to<T>(_ value: T) -> Signal<T, Error> {
        self.map { _ in value }
    }
    
    /// Map all values from a signal into an optional
    public func optional() -> Signal<Value?, Error> {
        self.map { $0 as Value? }
    }
}

extension SignalProducer {

    /// Map all values from a signal into an optional    
    public var optional: SignalProducer<Value?, Error> {
        self.lift { $0.optional() }
    }
    
    /// Convert a signalProducer value into `Void`
    public var void: SignalProducer<(), Error> {
        self.lift { $0.void }
    }
    
    /// Map all values from signal producer to a specific value
    public func to<T>(_ value: T) -> SignalProducer<T, Error> {
        self.lift { $0.to(value) }
    }
    
    /// Drop all errors and convert. Keepiung this private...
    func eraseError() -> SignalProducer<Value, Never> {
        self.flatMapError { error in
                .never
        }
    }
    
    /// Cast a signal to more specific type
    /// This needs more testing/refining
    /// Should pass an error if the cast fails?
    public func asType<ObjectType>(_ type: ObjectType.Type) -> SignalProducer<ObjectType, Error> {
        self.flatMap(.latest) { value -> SignalProducer<ObjectType, Error> in
            guard let value = value as? ObjectType else { return SignalProducer<ObjectType, Error>.never }
            
            return SignalProducer<ObjectType, Error>(value: value)
        }
    }
}

#if !os(macOS)
import UIKit

extension SignalProducer {
    /// Wraps all values in a simple animation block
    /// TODO: Add options for spring damping
    public func animated(duration: TimeInterval) -> SignalProducer<Value, Error> {
        
        return self.flatMap(.latest) { value in
            
            SignalProducer<Value, Error>.init { observer, _ in
                UIView.animate(withDuration: duration) { [weak observer] in
                    observer?.send(value: value)
                }
            }
        }
    }
}
#endif
