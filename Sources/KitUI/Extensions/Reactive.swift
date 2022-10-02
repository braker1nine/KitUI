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
    /// I'm also not sure it's necessary. I think ReactiveCocoa has this built in?
    public func `set`<T>(_ keyPath: ReferenceWritableKeyPath<Base, T>) -> BindingTarget<T> {
        makeBindingTarget { base, value in
            base[keyPath: keyPath] = value
        }
    }
}
