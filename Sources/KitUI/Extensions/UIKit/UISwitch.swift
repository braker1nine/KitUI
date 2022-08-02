//
//  UISwitch.swift
//

#if os(iOS)

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa

extension UISwitch {
    public convenience init(_ value: MutableProperty<Bool>) {
        self.init(frame: .zero)
        self.reactive.isOn <~ value.producer
        self.reactive.toggled = .init(Action<(), Bool, Never>.init(execute: { _ in
            value.value = self.isOn
            return .init(value: value.value)
        }))
    }
    
    public func onTint<T: SignalProducerConvertible>(color: T) -> Self where T.Value == UIColor {
        self.reactive.onTintColor <~ color.producer.eraseError()
        return self
    }
}

extension Reactive where Base: UISwitch {
    public var onTintColor: BindingTarget<UIColor> {
        makeBindingTarget { $0.onTintColor = $1 }
    }
}
#endif
