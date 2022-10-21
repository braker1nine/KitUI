//
//  UILabel.swift
//
#if os(iOS)

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa

extension UILabel {
    
    /// Initialize a `UILabel` with a reactive `String` value
    /// - parameter text: The `String` stream of values to bind to the `UILabel`
    /// - returns: A `UILabel` bound to the specified stream
    /// - note: Sets the `numberOfLines` to `0` to allow for multiline text
    public convenience init<T: SignalProducerConvertible>(
        _ text: T
    ) where T.Value == String {
        self.init()
        self.numberOfLines = 0
        self.adjustsFontForContentSizeCategory = true
        _ = self.text(text)
    }
    
    /// Initialize a label with a `String?` producer
    /// - parameter text: The `String?` producer to use for the label
    /// - returns: A `UILabel` with the specified text
    public convenience init<T: SignalProducerConvertible>(
        _ text: T
    ) where T.Value == String? {
        self.init(text.producer.map { $0 ?? ""})
    }
    
    /// Intialize a label with an attributed text producer
    /// - parameter text: The attributed text producer to use for the label
    /// - returns: A `UILabel` with the specified attributed text
    public convenience init<T: SignalProducerConvertible>(
        _ text: T
    ) where T.Value == NSAttributedString {
        self.init()
        self.numberOfLines = 0
        _ = self.attributedText(text)
    }
    
    /// Chainable method for setting the font of the label
    /// - parameter font: `UIFont?` The font to use for the label
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
    public func font<T: SignalProducerConvertible>(_ font: T) -> Self where T.Value == UIFont? {
        self.reactive.font <~ font.producer.eraseError()
        return self
    }
    
    /// Chainable method for setting the font of the label
    /// - parameter font: `UIFont` The font to use for the label
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
    public func font<T: SignalProducerConvertible>(_ font: T) -> Self where T.Value == UIFont {
        self.reactive.font <~ font.producer.eraseError()
        return self
    }
    
    /// Chainable method for setting the text of the label
    /// - parameter text: `String?` The text to use for the label
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
    public func text<T: SignalProducerConvertible>(_ text: T) -> Self where T.Value == String? {
        self.reactive.text <~ text.producer.eraseError()
        return self
    }
    
    /// Chainable Method for setting the text of the label
    /// - parameter text: `String` The text to use for the label
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
    public func text<T: SignalProducerConvertible>(_ text: T) -> Self where T.Value == String {
        self.reactive.text <~ text.producer.eraseError()
        return self
    }
    
    /// Chainable method for setting the text color of the label
    /// - parameter color: `UIColor` The color to use for the label
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
    public func color<T: SignalProducerConvertible>(_ color: T) -> Self where T.Value == UIColor {
        self.reactive.textColor <~ color.producer.eraseError()
        return self
    }
    
    /// Chainable method for setting the text alignment of the label
    /// - parameter alignment: `NSTextAlignment` The alignment to use for the label
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
    public func alignment<T: SignalProducerConvertible>(_ alignment: T) -> Self where T.Value == NSTextAlignment {
        self.reactive.textAlignment <~ alignment.producer.eraseError()
        return self
    }
    
    /// Chainable method for setting the number of lines of the label
    /// - parameter lines: `Int` The number of lines to use for the label
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
    public func numberOfLines<T: SignalProducerConvertible>(_ number: T) -> Self where T.Value == Int {
        self.reactive.numberOfLines <~ number.producer.eraseError()
        return self
    }
    
    /// Pass values from the producer to set the attributedText of the UILabel
    /// - parameter text: The `NSAttributedString` producer to use for the label
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
    /// - note: A bit of an experiment, but allowing this closure based version of the method
    /// allows consumers to run a complicated string generation inline? Might toss
    /// this eventually?
    public func attributedText<T: SignalProducerConvertible>(_ block: () -> T) -> Self where T.Value == NSAttributedString {
        let text = block()
        self.reactive.attributedText <~ text.producer.eraseError()
        return self
    }
    
    /// Chainable method for setting the attributed text of the label
    /// - parameter text: `SignalProducerConvertiable<NSAttributedString>` The attributed text to use for the label
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
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
