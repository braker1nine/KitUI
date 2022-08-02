//
//  UITextField.swift
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift

extension UITextField {
    
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
