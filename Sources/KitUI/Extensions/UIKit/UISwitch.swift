//
//  UISwitch.swift
//

#if os(iOS)

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa

extension UISwitch {

    /// Initialize a switch bound to a `MutableProperty<Bool>`
    /// - parameter property: The `MutableProperty<Bool>` to bind to the switch
    /// - returns: A `UISwitch` bound to the specified property
    public convenience init(_ value: MutableProperty<Bool>) {
        self.init(frame: .zero)
        self.reactive.isOn <~ value.producer
        self.reactive.toggled = .init(Action<(), Bool, Never>.init(execute: { _ in
            value.value = self.isOn
            return .init(value: value.value)
        }))
    }
    
    /// Chainable method for setting the `onTintColor` of the switch
    /// - parameter color: reactive `UIColor` stream of colors to use for the `onTintColor` of the switch
    /// - returns: The `UISwitch`
    /// - note: **Mutating modifier** modifies a property of the `UISwitch` 
    public func onTint(color: some SignalProducerConvertible<UIColor, Never>) -> Self {
        self.reactive.onTintColor <~ color.producer
        return self
    }
}

extension Reactive where Base: UISwitch {
    public var onTintColor: BindingTarget<UIColor> {
        makeBindingTarget { $0.onTintColor = $1 }
    }
}
#endif
