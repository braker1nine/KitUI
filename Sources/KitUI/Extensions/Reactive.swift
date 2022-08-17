//
//  Reactive.swift
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

extension Reactive where Base: NSObject {
    
    /// Experimental
    /// This allows you to create a `BindingTarget` for any KeyPath on demand. I'm not 100%
    /// sure this will work all the time
    public func `set`<T>(_ keyPath: ReferenceWritableKeyPath<Base, T>) -> BindingTarget<T> {
        makeBindingTarget { base, value in
            base[keyPath: keyPath] = value
        }
    }
}
