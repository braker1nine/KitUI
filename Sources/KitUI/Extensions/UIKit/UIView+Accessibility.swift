import Foundation
import ReactiveCocoa
import ReactiveSwift
import UIKit

/// Move these to KitUI
extension UIView {
    
    /// Chainable method for setting the accessibility identifier on a view
    /// - parameter value: A reactive value with a `String` to set as the accessibility identifier
    /// - returns: The view it was called on
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func accessibilityIdentifier(_ value: some SignalProducerConvertible<String, Never>) -> Self {
        self.reactive.accessibilityIdentifier <~ value.producer
        return self
    }
    
    /// Chainable method for setting the accessibility label on a view
    /// - parameter value: A reactive value with a `String?` to set as the accessibility label
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func accessibilityLabel(_ value: some SignalProducerConvertible<String, Never>) -> Self {
        self.reactive.accessibilityLabel <~ value.producer
        return self
    }
    
    /// Chainable method for setting the accessibility hint on a view
    /// - parameter value: A reactive `String` value to set as the accessibility hint
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func accessibilityHint(_ value: some SignalProducerConvertible<String, Never>) -> Self  {
        self.reactive.accessibilityHint <~ value.producer
        return self
    }
    
    /// Chainable method for setting the accessibility value on a view
    /// - parameter value: A reactive `String` value to set as the accessibility value
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func accessibilityValue(_ value: some SignalProducerConvertible<String, Never>) -> Self {
        value.producer.take(duringLifetimeOf: self).startWithValues { [weak self] text in
            self?.accessibilityValue = text
        }
        return self
    }
    
    /// Chainable method for setting the accessibility traits on a view
    /// - parameter value: A reactive `UIAccessibilityTraits` value to set as the accessibility traits
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func accessibilityTraits(_ traits: some SignalProducerConvertible<UIAccessibilityTraits, Never>) -> Self {
        traits.producer.take(duringLifetimeOf: self).startWithValues { [weak self] traits in
            self?.accessibilityTraits = traits
        }
        return self
    }
    
    /// Chainable method for setting `isAccessibilityElement` on a view
    /// - parameter value: A reactive `Bool` value to set as the `isAccessibilityElement`
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func isAccessibilityElement(_ value: some SignalProducerConvertible<Bool, Never>) -> Self {
        value.producer.take(duringLifetimeOf: self).startWithValues { [weak self] value in
            self?.isAccessibilityElement = value
        }
        return self
    }
}

extension Reactive where Base: UIView {
    public var accessibilityIdentifier: BindingTarget<String?> {
        makeBindingTarget { base, id in
            base.accessibilityIdentifier = id
        }
    }
    
    /// Binding Target for a UIView's `accessibilityLabel` property
    public var accessibilityLabel: BindingTarget<String?> {
        makeBindingTarget {
            $0.accessibilityLabel = $1
        }
    }
    
    public var accessibilityHint: BindingTarget<String?> {
        makeBindingTarget {
            $0.accessibilityHint = $1
        }
    }
}
