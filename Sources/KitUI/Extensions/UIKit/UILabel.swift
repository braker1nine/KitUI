//
//  UILabel.swift
//
#if os(iOS)

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa

extension UILabel {
    
    public convenience init<T: SignalProducerConvertible>(
        _ text: T
    ) where T.Value == String {
        self.init()
        self.numberOfLines = 0
        _ = self.text(text)
    }
    
    public func font<T: SignalProducerConvertible>(_ font: T) -> Self where T.Value == UIFont? {
        self.reactive.font <~ font.producer.eraseError()
        return self
    }
    
    public func font<T: SignalProducerConvertible>(_ font: T) -> Self where T.Value == UIFont {
        self.reactive.font <~ font.producer.eraseError()
        return self
    }
    
    public func text<T: SignalProducerConvertible>(_ text: T) -> Self where T.Value == String? {
        self.reactive.text <~ text.producer.eraseError()
        return self
    }
    
    public func text<T: SignalProducerConvertible>(_ text: T) -> Self where T.Value == String {
        self.reactive.text <~ text.producer.eraseError()
        return self
    }
    
    public func color<T: SignalProducerConvertible>(_ color: T) -> Self where T.Value == UIColor {
        self.reactive.textColor <~ color.producer.eraseError()
        return self
    }
    
    public func alignment<T: SignalProducerConvertible>(_ alignment: T) -> Self where T.Value == NSTextAlignment {
        self.reactive.textAlignment <~ alignment.producer.eraseError()
        return self
    }
    
    public func numberOfLines<T: SignalProducerConvertible>(_ number: T) -> Self where T.Value == Int {
        self.reactive.numberOfLines <~ number.producer.eraseError()
        return self
    }
}

extension Reactive where Base: UILabel {
    public var font: BindingTarget<UIFont?> {
        makeBindingTarget { $0.font = $1 }
    }
    
    public var textAlignment: BindingTarget<NSTextAlignment> {
        makeBindingTarget { $0.textAlignment = $1 }
    }
    
    public var numberOfLines: BindingTarget<Int> {
        makeBindingTarget { $0.numberOfLines = $1 }
    }
}
#endif
