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
    public convenience init(
        _ text: some SignalProducerConvertible<String?, Never>
    ) {
        self.init()
        self.numberOfLines = 0
        self.adjustsFontForContentSizeCategory = true
        _ = self.text(text)
    }
    
    /// Initialize a `UILabel` with a reactive `String` value
    /// - parameter text: The `String` stream of values to bind to the `UILabel`
    /// - returns: A `UILabel` bound to the specified stream
    /// - note: Sets the `numberOfLines` to `0` to allow for multiline text
    public convenience init(
        _ text: some SignalProducerConvertible<String, Never>
    ) {
        self.init(text.producer.map { $0 as String? })
    }
    
    /// Intialize a label with an attributed text producer
    /// - parameter text: The attributed text producer to use for the label
    /// - returns: A `UILabel` with the specified attributed text
    public convenience init(
        _ text: some SignalProducerConvertible<NSAttributedString, Never>
    ) {
        self.init()
        self.numberOfLines = 0
        _ = self.attributedText(text)
    }
    
    /// Chainable method for setting the font of the label
    /// - parameter font: `UIFont?` The font to use for the label
    /// - parameter scale: `Bool` indicating whether it should automatically scale
    /// - parameter relativeTo: `UIFont.TextStyle` indicates what metric to scale against. Nil value will use
    ///   the `UIFontMetrics.default`
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
    public func font(
        _ font: some SignalProducerConvertible<UIFont?, Never>,
        scale: Bool = true,
        relativeTo style: UIFont.TextStyle? = nil
    ) -> Self {
        self.reactive.font <~ font.producer.map { scale ? $0?.scaled(withStyle: style) : $0 }
        return self
    }
    
    /// Chainable method for setting the font of the label
    /// - parameter font: `UIFont` The font to use for the label
    /// - parameter scale: `Bool` indicating whether it should automatically scale
    /// - parameter relativeTo: `UIFont.TextStyle` indicates what metric to scale against. Nil value will use
    ///   the `UIFontMetrics.default`
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
    public func font(
        _ font: some SignalProducerConvertible<UIFont, Never>,
        scale: Bool = true,
        relativeTo style: UIFont.TextStyle? = nil
    ) -> Self {
        self.reactive.font <~ font.producer.map { scale ? $0.scaled(withStyle: style) : $0 }
        return self
    }
    
    /// Chainable method for setting the text of the label
    /// - parameter text: `String?` The text to use for the label
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
    public func text(_ text: some SignalProducerConvertible<String?, Never>) -> Self {
        self.reactive.text <~ text.producer.map(\.stringValue)
        return self
    }
    
    /// Chainable method for setting the text color of the label
    /// - parameter color: `UIColor` The color to use for the label
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
    public func color(_ color: some SignalProducerConvertible<UIColor, Never>) -> Self {
        self.reactive.textColor <~ color.producer
        return self
    }
    
    /// Chainable method for setting the text alignment of the label
    /// - parameter alignment: `NSTextAlignment` The alignment to use for the label
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
    public func alignment(_ alignment: some SignalProducerConvertible<NSTextAlignment, Never>) -> Self {
        self.reactive.textAlignment <~ alignment.producer
        return self
    }
    
    /// Chainable method for setting the number of lines of the label
    /// - parameter lines: `Int` The number of lines to use for the label
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
    public func numberOfLines(_ number: some SignalProducerConvertible<Int, Never>) -> Self {
        self.reactive.numberOfLines <~ number.producer
        return self
    }
    
    /// Pass values from the producer to set the attributedText of the UILabel
    /// - parameter text: The `NSAttributedString` producer to use for the label
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
    /// - note: A bit of an experiment, but allowing this closure based version of the method
    /// allows consumers to run a complicated string generation inline? Might toss
    /// this eventually?
    public func attributedText(
        _ block: () -> some SignalProducerConvertible<NSAttributedString, Never>
    ) -> Self {
        let text = block()
        self.reactive.attributedText <~ text.producer
        return self
    }
    
    /// Chainable method for setting the attributed text of the label
    /// - parameter text: `SignalProducerConvertiable<NSAttributedString>` The attributed text to use for the label
    /// - returns: The `UILabel`
    /// - note: **Mutating modifier** modifies a property of the `UILabel`
    public func attributedText(_ value: some SignalProducerConvertible<NSAttributedString, Never>) -> Self {
        self.reactive.attributedText <~ value.producer
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
