//
//  Constraint.swift
//


import Foundation
#if canImport(UIKit)
import UIKit
#endif
import ReactiveCocoa
import ReactiveSwift
import TinyConstraints

extension Reactive where Base: Constraint {
    
    #if canImport(UIKit)
    /// BindingTarget for a constraint's priority
    public var priority: BindingTarget<UILayoutPriority> {
        makeBindingTarget { (constraint, priority) in
            constraint.priority = priority
        }
    }
    #endif
    
    /// BindingTarget for a constraint's active state
    public var isActive: BindingTarget<Bool> {
        makeBindingTarget { (constraint, isActive) in
            constraint.isActive = isActive
        }
    }
}

extension Constraint {
    @discardableResult
    public func isActive(_ isActive: some SignalProducerConvertible<Bool, Never>) -> Constraint {
        self.reactive.isActive <~ isActive.producer
        return self
    }
}

extension Constraints {
    @discardableResult
    public func isActive(_ isActive: some SignalProducerConvertible<Bool, Never>) -> Constraints {
        for constraint in self {
            constraint.reactive.isActive <~ isActive.producer
        }
        return self
    }
}
