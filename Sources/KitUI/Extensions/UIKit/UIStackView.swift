//
//  UIStackView.swift
//
#if os(iOS)

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa

extension UIStackView {
    
    /// Initialize a stack view with the specified properties
    /// - note: Prefer using chainable methods rather than this initializer
    public convenience init(
        axis: NSLayoutConstraint.Axis = .vertical,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment =  .fill,
        spacing: CGFloat = 0,
        @UIViewBuilder builder: () -> [UIView]
    ) {
        self.init(frame: .zero)
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
        
        self.isUserInteractionEnabled = true
        self.setHugging(.init(rawValue: 751), for: .vertical)
        self.setHugging(.init(rawValue: 751), for: .horizontal)
        for view in builder().compactMap({ $0 }) {
            self.addArrangedSubview(view)
        }
    }
    
    /// Initialize a stack view with the specified properties
    /// - note: Prefer using chainable methods rather than this initializer
    public convenience init<
        T: SignalProducerConvertible,
        U: SignalProducerConvertible,
        V: SignalProducerConvertible,
        X: SignalProducerConvertible
    >(
        axis: T = NSLayoutConstraint.Axis.vertical as! T,
        distribution: U = UIStackView.Distribution.fill as! U,
        alignment: V = UIStackView.Alignment.fill as! V,
        spacing: X = CGFloat(0.0) as! X,
        @UIViewBuilder builder: () -> [UIView]
    ) where T.Value == NSLayoutConstraint.Axis,
    U.Value == UIStackView.Distribution,
    V.Value == UIStackView.Alignment,
    X.Value == CGFloat
    {
        self.init(frame: .zero)
        self.reactive.axis <~ axis.producer.eraseError()
        self.reactive.distribution <~ distribution.producer.eraseError()
        self.reactive.alignment <~ alignment.producer.eraseError()
        self.reactive.spacing <~ spacing.producer.eraseError()
        self.isUserInteractionEnabled = true
        self.setHugging(.init(rawValue: 751), for: .vertical)
        self.setHugging(.init(rawValue: 751), for: .horizontal)
        for view in builder().compactMap({ $0 }) {
            self.addArrangedSubview(view)
        }
    }
    
    /// Removes all arrangedSubviews from the stack view
    @objc public func removeAllArrangedSubviews() {
        let subviews = self.arrangedSubviews
        subviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    /// Chainable method for setting a reactive axis
    /// - parameter axis: Property with the current axis value
    /// - returns self
    /// - note: **Mutating Modifier** modifies a property of the `UIStackView`
    @discardableResult
    public func axis<T: SignalProducerConvertible>(_ axis: T) -> Self where T.Value == NSLayoutConstraint.Axis {
        self.reactive.axis <~ axis.producer.eraseError()
        return self
    }
    
    /// Chainable method for setting a reactive spacing
    /// - parameter axis: Property with the current spacing value
    /// - returns self
    /// - note: **Mutating Modifier** modifies a property of the `UIStackView`
    @discardableResult
    public func spacing<T: SignalProducerConvertible>(_ value: T) -> Self where T.Value == Double {
        self.reactive.spacing <~ value.producer.map { CGFloat($0) }.eraseError()
        return self
    }
    
    /// Chainable method for setting a reactive distribution
    /// - parameter value: Reactive `UIStackView.Distribution` value
    /// - returns self
    /// - note: **Mutating Modifier** modifies a property of the `UIStackView`
    @discardableResult
    public func distribution<T: SignalProducerConvertible>(_ value: T) -> Self where T.Value == UIStackView.Distribution {
        self.reactive.distribution <~ value.producer.eraseError()
        return self
    }
    
    /// Chainable method for setting a reactive alignment
    /// - parameter value: Reactive `UIStackView.Alignment` value
    /// - returns self
    /// - note: **Mutating Modifier** modifies a property of the `UIStackView`
    @discardableResult
    public func alignment<T: SignalProducerConvertible>(_ value: T) -> Self where T.Value == UIStackView.Alignment {
        self.reactive.alignment <~ value.producer.eraseError()
        return self
    }
}

extension Reactive where Base: UIStackView {

    /// BindingTarget for the `spacing` property
    public var spacing: BindingTarget<CGFloat> {
        makeBindingTarget { (view, spacing) in
            view.spacing = spacing
        }
    }
    
    /// BindingTarget for the `axis` property
    public var axis: BindingTarget<NSLayoutConstraint.Axis> {
        makeBindingTarget { (view, axis) in
            view.axis = axis
        }
    }
    
    /// BindingTarget for the `distribution` property
    public var distribution: BindingTarget<UIStackView.Distribution> {
        makeBindingTarget { (view, distribution) in
            view.distribution = distribution
        }
    }
    
    /// BindingTarget for the `alignment` property
    public var alignment: BindingTarget<UIStackView.Alignment> {
        makeBindingTarget { (view, alignment) in
            view.alignment = alignment
        }
    }
}
#endif