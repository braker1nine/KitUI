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
        self.adjustsFontForContentSizeCategory = true
        _ = self.text(text)
    }
    
    public convenience init<T: SignalProducerConvertible>(
        text: T
    ) where T.Value == String? {
        self.init(text.producer.map { $0 ?? ""})
    }
    
    public convenience init<T: SignalProducerConvertible>(
        _ text: T
    ) where T.Value == NSAttributedString {
        self.init()
        self.numberOfLines = 0
        _ = self.attributedText(text)
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
    
    /// Pass values from the producer to set the attributedText of the UILabel
    ///
    /// A bit of an experiment, but allowing this closure based version of the method
    /// allows consumers to run a complicated string generation inline? Might toss
    /// this eventually?
    public func attributedText<T: SignalProducerConvertible>(_ block: () -> T) -> Self where T.Value == NSAttributedString {
        let text = block()
        self.reactive.attributedText <~ text.producer.eraseError()
        return self
    }
    
    public func attributedText<T: SignalProducerConvertible>(_ value: T) -> Self where T.Value == NSAttributedString {
        self.reactive.attributedText <~ value.producer.eraseError()
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
