//
//  UITextField.swift
//

#if os(iOS)

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift

extension UITextField {
    
    /// Send a stream of values to the text of the textField
    /// - parameter text: The stream of values to send to the text of the textField
    /// - returns: The `UITextField` it's called on
    /// - note: **Modifies the `UITextField`**
    public func text<T: SignalProducerConvertible>(_ text: T) -> Self where T.Value: Stringish {
        self.reactive.text <~ text.producer.map(\.stringValue).eraseError()
        return self
    }
    
}

extension Reactive where Base: UITextField {
    public var attributedPlaceholder: BindingTarget<NSAttributedString?> {
        makeBindingTarget { textField, attributedString in
            textField.attributedPlaceholder = attributedString
        }
    }
}
#endif