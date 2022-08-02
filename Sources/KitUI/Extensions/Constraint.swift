//
//  Constraint.swift
//

#if !os(macOS)

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift
import TinyConstraints

extension Reactive where Base: Constraint {
    
    /// BindingTarget for a constraint's priority
    public var priority: BindingTarget<UILayoutPriority> {
        makeBindingTarget { (constraint, priority) in
            constraint.priority = priority
        }
    }
    
    /// BindingTarget for a constraint's active state
    public var isActive: BindingTarget<Bool> {
        makeBindingTarget { (constraint, isActive) in
            constraint.isActive = isActive
        }
    }
}
#endif
