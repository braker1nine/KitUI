//
//  Values+SignalProducerConvertible.swift
//

import Foundation
import ReactiveSwift
import CoreGraphics

#if os(iOS)
import UIKit
#endif

#if os(iOS)
/// `SignalProducerConvertible` for `CGFloat`
/// - note: Sends the value once
extension CGFloat: SignalProducerConvertible {
    public typealias Value = CGFloat
    public typealias Error = Never
    
    public var producer: SignalProducer<CGFloat, Never> { .init(value: self) }
}

/// `SignalProducerConvertible` conformance for `BorderStyle`
/// - note: Sends the value once
extension BorderStyle: SignalProducerConvertible {
    public var producer: SignalProducer<BorderStyle, Never> { .init(value: self) }
}

/// `SignalProducerConvertible` conformance for `UIColor`
/// - note: Sends the value once
extension UIColor: SignalProducerConvertible {
    public var producer: SignalProducer<UIColor, Never> { .init(value: self) }
}

/// `SignalProducerConvertible` conformance for `UIAccessibilityTraits`
/// - note: Sends the value once
extension UIAccessibilityTraits: SignalProducerConvertible {
    public var producer: SignalProducer<UIAccessibilityTraits, Never> { .init(value: self) }
}


extension UIFont: SignalProducerConvertible {
    public var producer: SignalProducer<UIFont, Never> { .init(value: self) }
}

extension NSLayoutConstraint.Axis: SignalProducerConvertible {
    public var producer: SignalProducer<NSLayoutConstraint.Axis, Never> { .init(value: self) }
}

extension UIStackView.Distribution: SignalProducerConvertible {
    public var producer: SignalProducer<UIStackView.Distribution, Never> { .init(value: self) }
}

extension UIStackView.Alignment: SignalProducerConvertible {
    public var producer: SignalProducer<UIStackView.Alignment, Never> { .init(value: self) }
}

extension CGAffineTransform: SignalProducerConvertible {
    public var producer: SignalProducer<CGAffineTransform, Never> { .init(value: self) }
}

extension CACornerMask: SignalProducerConvertible {
    public var producer: SignalProducer<CACornerMask, Never> { .init(value: self) }
}

extension CGSize: SignalProducerConvertible {
    public var producer: SignalProducer<CGSize, Never> { .init(value: self) }
}

extension UIImage: SignalProducerConvertible {
    public var producer: SignalProducer<UIImage, Never> { .init(value: self) }
}

extension NSTextAlignment: SignalProducerConvertible {
    public var producer: SignalProducer<NSTextAlignment, Never> { .init(value: self) }
}
#endif

extension Bool: SignalProducerConvertible {
    public var producer: SignalProducer<Bool, Never> { .init(value: self) }
}

extension String: SignalProducerConvertible {
    
    public var producer: SignalProducer<String, Never> { .init(value: self) }
}

extension Int: SignalProducerConvertible {
    
    public var producer: SignalProducer<Int, Never> { .init(value: self) }
}

extension Double: SignalProducerConvertible {
    
    public var producer: SignalProducer<Double, Never> { .init(value: self) }
}

extension Float: SignalProducerConvertible {
    
    public var producer: SignalProducer<Float, Never> { .init(value: self) }
}

extension Optional: SignalProducerConvertible {
    public var producer: SignalProducer<Wrapped?, Never> { .init(value: self) }
}

extension NSAttributedString: SignalProducerConvertible {
    public var producer: SignalProducer<NSAttributedString, Never> { .init(value: self) }
}

extension UIEdgeInsets: SignalProducerConvertible {
    public var producer: SignalProducer<UIEdgeInsets, Never> { .init(value: self) }
}

extension WrapConfiguration: SignalProducerConvertible {
    public var producer: SignalProducer<WrapConfiguration, Never> { .init(value: self) }
}
